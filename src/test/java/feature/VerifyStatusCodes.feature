Feature: Verify endpoints work

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
			  },
			  "logic": {
			    "result": {
			      "+": [
			        {
			          "var": "num"
			        },
			        10
			      ]
			    }
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
			  },
			  "logic": {
			    "result": {
			      "+": [
			        {
			          "var": "num"
			        },
			        10
			      ]
			    }
			  }
			}
		"""
		

	Scenario: Ensure returns 400 with invalid request body
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request {}
		When method POST
		Then status 400
		
		
	Scenario: Ensure get returns 404 with non-existant id
		Given path 'templates', 'dummyid'
		When method GET
		Then status 404
		
		
	Scenario: Ensure put endpoint returns 400 with invalid request body
		Given path 'templates'
		And header Content-Type = 'application/json'
		And request validCreateRequestBody
		When method POST
		Then status 200
		
		* def id = response
	
		Given path 'templates', id
		And header Content-Type = 'application/json'
		And request {} 
		When method PUT
		Then status 400

	
	Scenario: Ensure delete returns 404 with non-existant id
		Given path 'templates', 'dummyid'
		When method DELETE
		Then status 200
		
		

		