pipeline {
   agent any
    environment {
        deploy_dir = '/usr/local/nginx/html/book/system_security'
        JENKINS_NODE_COOKIE ='dontkillme'
   }

   stages {
      stage('copy content to ${deploy_dir}') {
         steps {
            sh """
                /bin/cp -Rf ./* ${deploy_dir}/
                cd ${deploy_dir} && sh ./generate_html.sh
                cd /usr/local/nginx/html/vip_itgod && sh ./control_uwsgi.sh restart

            """
         }
      }
   }
}