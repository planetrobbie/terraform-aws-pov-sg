output "vpc_id" {
  description = "VPC ID where to launch our instance."
  value       = "${data.terraform_remote_state.vpc.vpc_id}"
}
