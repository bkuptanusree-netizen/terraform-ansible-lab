pipeline {
               agent any
			   environment  {
				   TF_IN_AUTOMATION = "true"
			   }
			   stages {
				   stage('Checkout') {
					   steps {
						   checkout scm
					   }
				   }
	
               
                	stage('Terraform Init') {
		          		steps {
					  withCredentials([[
						  $class: 'AmazonWebServicesCredentialsBinding',
						  credentialsId: 'aws_creds'
						  ]]) {
                                      sh 'terraform init -no-color'
                              }
                       }
					   }
                       stage('Terraform Plan') {
                        	steps {
						withCredentials([[
						  	$class: 'AmazonWebServicesCredentialsBinding',
						  	credentialsId: 'aws_creds'
						  	]]) {
                                     sh 'terraform plan -no-color -input=false'
                              }
                        }
					   }
                        stage('Terraform Apply') {
                              steps {
							withCredentials([[
						  		$class: 'AmazonWebServicesCredentialsBinding',
						  		credentialsId: 'aws_creds'
						  		]]) {
                                      sh 'terraform apply -auto-approve -no-color -input=false'
                               }
                         }
					}
						   
                  }
           }
 

