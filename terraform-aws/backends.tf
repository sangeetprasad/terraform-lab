terraform {
  backend "remote" {
    organization = "sangeetprasad"

    workspaces {
      name = "sangeetprasad-dev"
    }
  }
}