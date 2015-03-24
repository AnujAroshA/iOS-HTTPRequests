<?php
    
    function getStatusCodeMessage($status)
    {
        $codes = Array(
                       100 => 'Continue',
                       101 => 'Switching Protocols',
                       200 => 'OK',
                       201 => 'Created',
                       202 => 'Accepted',
                       203 => 'Non-Authoritative Information',
                       204 => 'No Content',
                       205 => 'Reset Content',
                       206 => 'Partial Content',
                       300 => 'Multiple Choices',
                       301 => 'Moved Permanently',
                       302 => 'Found',
                       303 => 'See Other',
                       304 => 'Not Modified',
                       305 => 'Use Proxy',
                       306 => '(Unused)',
                       307 => 'Temporary Redirect',
                       400 => 'Bad Request',
                       401 => 'Unauthorized',
                       402 => 'Payment Required',
                       403 => 'Forbidden',
                       404 => 'Not Found',
                       405 => 'Method Not Allowed',
                       406 => 'Not Acceptable',
                       407 => 'Proxy Authentication Required',
                       408 => 'Request Timeout',
                       409 => 'Conflict',
                       410 => 'Gone',
                       411 => 'Length Required',
                       412 => 'Precondition Failed',
                       413 => 'Request Entity Too Large',
                       414 => 'Request-URI Too Long',
                       415 => 'Unsupported Media Type',
                       416 => 'Requested Range Not Satisfiable',
                       417 => 'Expectation Failed',
                       500 => 'Internal Server Error',
                       501 => 'Not Implemented',
                       502 => 'Bad Gateway',
                       503 => 'Service Unavailable',
                       504 => 'Gateway Timeout',
                       505 => 'HTTP Version Not Supported'
                       );
        
        return (isset($codes[$status])) ? $codes[$status] : '';
    }
    
    function sendResponse($status = 200, $body = '', $content_type = 'application/json')
    {
        $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
        header($status_header);
        header('Content-type: ' . $content_type);
        echo $body;
    }
    
    class RedeemAPI {
        
        function redeem() {
            
            /*
             *  POST request handle
             */
            
            // Check for POST data "name" key
            if (isset($_POST["name"])) {

                // Inspecting request headers
                $request_headers = getallheaders();
                
                // Check for the custom header field and it's value
                if(isset($request_headers['X-USERNAME']) && $request_headers['X-USERNAME'] == 'apiuser') {
                    
                    // Assign the value for the key "name" to a string variable
                    $name = $_POST["name"];
                    
                    // Convert the key-value to a JSON object
                    $result = json_encode(array('name' => $name), JSON_FORCE_OBJECT);
                    
                    sendResponse(200, json_encode($result));
                    
                    return true;
                }
                
                sendResponse(203, 'Non-Authoritative Information');
                return false;
            }
            
            /*
             *  GET request handle
             */
            
            // Check for GET request "name" key
            if (isset($_GET["name"])) {
                
                /*
                 *  For custome headers
                 *  Returns a JSON object
                 */
                
//                $request_headers = getallheaders();
//                
//                if(isset($request_headers['X-USERNAME']) && $request_headers['X-USERNAME'] == 'apiuser') {
//                    
//                    $name = $_GET["name"];
//                    
//                    $result = json_encode(array('name' => $name), JSON_FORCE_OBJECT);
//                    
//                    sendResponse(200, json_encode($result));
//                    
//                    return true;
//                }
//                
//                sendResponse(203, 'Non-Authoritative Information');
//                return false;
                

                /*
                 *  For default headers
                 *  Returns a normal string
                 */
                
                $name = $_GET["name"];
                sendResponse(200, $name);
                return true;
            }
            
            sendResponse(400, 'Invalid request');
            return false;
        }
    }
    
    $api = new RedeemAPI;
    $api->redeem();
    
?>