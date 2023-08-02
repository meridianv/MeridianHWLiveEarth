Feature: Verify application logic is correct

  Background: 
    # base url
    * url "http://0.0.0.0:6250"
    
    # payloads
    * def validCreateRequestBody =
      """
      	{
      	  "name": "Test name",
      	  "description": "Test description.",
      	  "template": "<h1>salary: {{salary}} raise: {{raise}}</h1>",
      	  "headers": [
      	    {
      	      "name": "Content-Type",
      	      "value": "text/html"
      	    }
      	  ],
      	  "dataSchema": {
      	    "type": "object",
      	    "properties": {
      	      "salary": {
      	        "type": "number"
      	      }
      	    },
      	    "required": [
      	      "salary"
      	    ]
      	  },
      	  "logic": {
      	    "raise": {
      	      "*": [
      	        {
      	          "var": "salary"
      	        },
      	        0.15
      	      ]
      	    }
      	  }
      	}
      """
   

  Scenario: Ensure headers are saved correcly
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
		
		Given path 'templates', id
		When method GET
		Then status 200
		And match response contains { headers: [ {name: "Content-Type", value: "text/html" } ] }
		
		
	Scenario: Ensure logic is working correctly
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
		
		Given path 'templates', id, 'process'
		And header Content-Type = 'application/json'
		And request {salary: 5000}
		When method POST	
		Then status 200
		And match response contains '5000'
		And match response contains '750'
		
	Scenario: Ensure omitting required parameters cause processing to fail
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
		
		Given path 'templates', id, 'process'
		And header Content-Type = 'application/json'
		And request {}
		When method POST	
		Then status 400
		