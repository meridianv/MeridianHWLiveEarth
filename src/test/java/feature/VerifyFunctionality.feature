Feature: Verify status codes are correct

	Background:
		# base url
		* url "http://0.0.0.0:6250"
		
		# payloads
		* def validCreateRequestBody =
		"""
			{
			  "name": "Test name",
			  "description": "Test description.",
			  "template": "<h1>Hi. My name is {{name}}</h1>",
			  "headers": [
			    {
			      "name": "Content-Type",
			      "value": "text/html"
			    }
			  ],
			  "dataSchema": {
			    "type": "object",
			    "properties": {
			      "name": {
			        "type": "string"
			      }
			    },
			    "required": [
			      "name"
			    ]
			  }
			}
		"""
		
		* def validUpdateRequestBody =
		"""
			{
			  "name": "New test name",
			  "description": "New test description.",
			  "template": "<h1>Hi. My name is {{name}}</h1>",
			  "headers": [
			    {
			      "name": "Content-Type",
			      "value": "text/html"
			    }
			  ],
			  "dataSchema": {
			    "type": "object",
			    "properties": {
			      "name": {
			        "type": "string"
			      }
			    },
			    "required": [
			      "name"
			    ]
			  }
			}
		"""
		
		

	Scenario: Ensure create endpoints works
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		And match response == '#string'
		
	Scenario: Ensure get endpoint works
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
		
		Given path 'templates', id
		When method GET
		Then status 200
		
	Scenario: Ensure put endpoint works
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
	
		Given path 'templates', id
		And header Content-Type = 'application/json'
		And request validUpdateRequestBody
		When method PUT
		Then status 200
		
		Given path 'templates', id
		When method GET
		Then status 200
		And match response.name == 'New test name'
		And match response.description == 'New test description.'
	
	Scenario: Ensure delete endpoint works
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
		
		Given path 'templates', id
		When method DELETE
		Then status 200
		
	Scenario: Ensure process endpoint works
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
		
		Given path 'templates', id, 'process'
		And header Content-Type = 'application/json'
		And request {name: "John"}
		When method POST
		Then status 200
		And match response contains 'John'
		
		
		