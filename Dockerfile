FROM ruby:alpine

RUN apk update && apk upgrade
RUN apk add make curl jq bash openssl python py-pip
RUN pip install awscli
RUN gem install stackup

ENV KUBEVERSION 1.11.5
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBEVERSION}/bin/linux/amd64/kubectl \
  && chmod +x kubectl \
  && mv kubectl /usr/local/bin/
RUN curl -LO https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBEVERSION}/2018-12-06/bin/linux/amd64/aws-iam-authenticator \
  && chmod +x aws-iam-authenticator \
  && mv aws-iam-authenticator /usr/local/bin/

ENTRYPOINT [ "bash" ]
