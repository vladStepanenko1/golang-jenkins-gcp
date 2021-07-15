terraform {
  backend "gcs" {
    bucket = "flask-app-318214-tfstate"
    prefix = "/env/dev"
  }
}