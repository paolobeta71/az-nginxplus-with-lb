var responseBody = '';
function getResponseBody(r, data, flags) {
            responseBody += data;
            r.sendBuffer(data, flags);
        return JSON.stringify({
                        "Body Response": responseBody
                    });
}

export default {getResponseBody}