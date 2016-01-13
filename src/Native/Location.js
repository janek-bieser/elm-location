Elm.Native = Elm.Native || {};
Elm.Native.Location = Elm.Native.Location || {};

Elm.Native.Location.make = function make(localRuntime) {

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Location = localRuntime.Native.Location || {};

    if (localRuntime.Native.Location.values) {
        return localRuntime.Native.Location.values;
    }

    var Signal = Elm.Native.Signal.make(localRuntime);
    var Task = Elm.Native.Task.make(localRuntime);

    var makeLocation = function() {
        return {
            ctor: "Location",
            _0: {
                path: window.location.pathname || "",
                hash: window.location.hash || "",
                search: window.location.search || ""
            }
        };
    };

    var location = Signal.input(
        "Location.location",
        makeLocation()
    );

    localRuntime.addListener([location.id], window, "popstate", function() {
        localRuntime.notify(location.id, makeLocation());
    });

    localRuntime.addListener([location.id], window, "hashchange", function() {
        localRuntime.notify(location.id, makeLocation());
    });

    return {
        location: location,

        currentLocation: Task.asyncFunction(function(callback) {
            var loc = makeLocation();
            localRuntime.notify(location.id, loc);
            callback(Task.succeed(loc));
        }),

        /**
         * calls window.history.pushState and notifies the location signal.
         */
        pushState: function(url) {
            return Task.asyncFunction(function(callback) {
                window.history.pushState({}, "", url);
                var loc = makeLocation();
                localRuntime.notify(location.id, loc);
                callback(Task.succeed(loc));
            });
        },

        /**
         * calls window.history.replaceState and notifies the location signal.
         */
        replaceState: function(url) {
            return Task.asyncFunction(function(callback) {
                window.history.replaceState({}, "", url);
                var loc = makeLocation();
                localRuntime.notify(location.id, loc);
                callback(Task.succeed(loc));
            });
        },

        /**
         * calls window.history.go and notifies the location signal.
         */
        go: function(offset) {
            return Task.asyncFunction(function(callback) {
                offset || (offset = 0);
                window.history.go(offset);
                callback(Task.succeed(makeLocation()));
            });
        }
    };
};

