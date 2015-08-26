
function create_namespace(name){
    var names = name.split('.');
    var current = window;
    
    $.each(names, function(idx, name){
        current[name] = current[name] || {};
        current = current[name];
    });
    
    return current;
}

create_namespace('app.Dashboard');


app.Dashboard.CreateViewController = function() {
   $("[data-toggle='tooltip']").tooltip();
}

app.Dashboard.CreateViewController.prototype = { 

}