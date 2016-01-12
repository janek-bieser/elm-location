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
            path: window.location.pathname || "",
            hash: window.location.hash || "",
            search: window.location.search || ""
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

        pushState: function(url) {
            return Task.asyncFunction(function(callback) {
                window.history.pushState({}, "", url);
                localRuntime.notify(location.id, makeLocation());
                callback(Task.succeed(makeLocation()));
            });
        },

        currentLocation: Task.asyncFunction(function(callback) {
            callback(Task.succeed(makeLocation()));
        })
    };
};

