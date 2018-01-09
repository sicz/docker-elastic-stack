require "docker_helper"

### KIBANA #####################################################################

describe "Kibana", :test => :kb do
  hostname = ENV["KIBANA_URL"].sub(/^\w+:\/\//, "").sub(/:.*/, "")
  port = ENV["KIBANA_URL"].sub(/^.*:/, "")

  ### DOCKER_CONTAINER #########################################################

  describe docker_container(ENV["KIBANA_CONTAINER"]) do
    it { is_expected.to be_running }
  end

  ### KIBANA ###################################################################

  describe host(hostname) do
    it { is_expected.to be_reachable.with(:port => port, :timeout => 1) }
  end

  describe "Endpoint" do
    [
      # [url, stdout, stderr]
      [
        "#{ENV["KIBANA_URL"]}/api/status",
        "\"status\":{\"overall\":{\"state\":\"green\"",
        "^< kbn-version: #{ENV["KIBANA_VERSION"]}\\r$",
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
