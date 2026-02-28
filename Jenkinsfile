pipeline {
               agent any
			   environment  {
				   TF_IN_AUTOMATION = "true"
			   }
	
               
               stages {
                       stage('Terraform Init') {
		          steps {
					  withCredentials([[
						  $class: 'AmazonWebServicesCredentialsBinding',
						  credentialsId: 'aws-creds'
						  ]]) {
                                      sh 'terraform init'
                              }
                       }
                       stage('Terraform Plan') {
                             steps {
						withCredentials([[
						  	$class: 'AmazonWebServicesCredentialsBinding',
						  	credentialsId: 'aws-creds'
						  	]]) {
                                     sh 'terraform plan -no-color -input=false'
                              }
                        }
					   }
                        stage('Terraform Apply') {
                              steps {
							withCredentials([[
						  		$class: 'AmazonWebServicesCredentialsBinding',
						  		credentialsId: 'aws-creds'
						  		]]) {
                                      sh 'terraform apply -auto-approve -no-color -input=false'
                               }
                         }
					}
						   
                  }
           }
 

