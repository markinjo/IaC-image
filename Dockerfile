FROM alpine:latest

# Postavljanje ENV promenljivih
ENV TERRAFORM_VERSION=1.6.0 \
    TFLINT_VERSION=0.50.3 \
    CHECKOV_VERSION=3.1.48 \
    AWS_CLI_VERSION=2.15.0

# Instalacija osnovnih paketa
RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    python3 \
    py3-pip \
    jq \
    git

# Kreiranje Python virtualnog okruženja za Checkov
RUN python3 -m venv /opt/venv \
    && source /opt/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install checkov==${CHECKOV_VERSION} \
    && deactivate

# Dodavanje Checkov u PATH
ENV PATH="/opt/venv/bin:$PATH"

# Instalacija Terraform-a
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip \
    && unzip terraform.zip -d /usr/local/bin/ \
    && rm terraform.zip

# Instalacija TFLint-a
RUN curl -fsSL "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" -o tflint.zip \
    && unzip tflint.zip -d /usr/local/bin/ \
    && rm tflint.zip

# Instalacija AWS CLI-a
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Podešavanje radnog direktorijuma
WORKDIR /app

# Podrazumevani komandni interpreter
ENTRYPOINT ["/bin/bash"]
