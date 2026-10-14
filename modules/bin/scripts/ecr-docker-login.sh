# shellcheck shell=bash
# Packaged by modules/bin (writeShellApplication sets errexit and pipefail).

show_help() {
    cat <<EOF
ecr-docker-login:
  Log into ECR with docker without breaking a sweat!

Usage:
  ecr-docker-login [options]

Options:
  -p <profile>                          AWS profile to use (default: \$AWS_PROFILE).
  -r <region>                           AWS region to use (default: us-east-1).
  -l                                    List named profiles.
  -h                                    Show help and usage information.
EOF
}

die() {
    printf '\033[31m%s\033[0m\n' "$1" >&2
    exit 1
}

profile="${AWS_PROFILE:-}"
region="us-east-1"

while getopts "hlp:r:" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    l)
        aws configure list-profiles
        exit 0
        ;;
    p)
        profile="$OPTARG"
        ;;
    r)
        region="$OPTARG"
        ;;
    *)
        show_help >&2
        exit 2
        ;;
    esac
done

if [ -z "$profile" ]; then
    die "Profile not provided, either provide a profile with -p or set AWS_PROFILE!"
fi

registry_id=$(aws --profile "$profile" --region "$region" ecr describe-registry --query 'registryId' --output text)

aws --profile "$profile" --region "$region" ecr get-login-password |
    docker login --username AWS --password-stdin "$registry_id.dkr.ecr.$region.amazonaws.com"
