require "docker_helper"

### ELASTICSEARCH ##############################################################

describe "Elasticsearch", :test => :es do
  hostname = ENV["ELASTICSEARCH_URL"].sub(/^\w+:\/\//, "").sub(/:.*/, "")
  port = ENV["ELASTICSEARCH_URL"].sub(/^.*:/, "")

  ### DOCKER_CONTAINER #########################################################

  describe docker_container(ENV["ELASTICSEARCH_CONTAINER"]) do
    it { is_expected.to be_running }
  end

  ### ELASTICSEARCH ############################################################

  describe host(hostname) do
    it { is_expected.to be_reachable.with(:port => port, :timeout => 1) }
  end

  describe "Endpoint" do
    [
      # [url, stdout, stderr]
      [
        "#{ENV["ELASTICSEARCH_URL"]}",
        "\"number\" : \"#{ENV["ELASTICSEARCH_VERSION"]}\"",
        "^< Content-Type: application\\/json; charset=UTF-8\\r$",
      ],
      [
        "#{ENV["ELASTICSEARCH_URL"]}/_cluster/health",
        "\"status\":\"(green|yellow)\"",
        "^< Content-Type: application\\/json; charset=UTF-8\\r$"
      ],
    ].each do |url, stdout, stderr|
      context url do
        subject { command("curl --location --silent --show-error --verbose #{url}") }
        it "should exist" do
          expect(subject.exit_status).to eq(0)
        end
        it "should match /#{stdout}/" do
          expect(subject.stdout).to match(/#{stdout}/i)
        end unless stdout.nil?
        it "should match /#{stderr}/" do
          expect(subject.stderr).to match(/#{stderr}/i)
        end unless stderr.nil?
      end
    end
  end

  ##############################################################################

end
