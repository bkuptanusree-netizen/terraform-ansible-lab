pipeline {
               agent any
               
               stages {
                       stage('Terraform Init') {
		          steps {
                                      sh 'terraform init'
                              }
                       }
                       stage('Terraform Plan') {
                             steps {
                                     sh '''
									 terraform plan \
									 	-no-color \
										-input=false \
										-lock=false
									 '''
                              }
                        }
                        stage('Terraform Apply') {
                              steps {
                                      sh '''
								  	  terraform apply \
								  		-auto-approve \
										-no-color \
										-input=false
								  	  '''
                               }
                         }
				         stage('Checkout') {
							 steps {
								 git 'git@github.com:bkuptanusree-netizen/terraform-ansible-lab.git'
							 }
						 }				   
                  }
           }
 

