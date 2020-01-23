import user_services;
import ballerina/http;
import ballerina/io;

listener http:Listener listenerEp = new (9090);

@http:ServiceConfig {
    basePath: "form"
}

service studentForm on listenerEp {
    @http:ResourceConfig {
        methods: ["POST"],        //only POST requests are allowed
        path: "submission"
    }

    resource function submit(http:Caller caller, http:Request request) {
        var data = request.getFormParams();
        io:println(data);
        if (data is map<string>) {
            //create new github post request with the username = this.state.fullname
            user_services:postRequest(caller, request, data.entries().get("fullname"));
        }

        json success = {"status": "form submitted successfully"};
        http:Response response = new;
        response.setPayload(success);
        checkpanic caller->respond(response);
    }
}

