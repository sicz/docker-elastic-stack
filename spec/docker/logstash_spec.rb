require "docker_helper"

### LOGSTASH ###################################################################

describe "Logstash", :test => :ls do
  hostname = ENV["LOGSTASH_URL"].sub(/^\w+:\/\//, "").sub(/:.*/, "")
  port = ENV["LOGSTASH_URL"].sub(/^.*:/, "")

  ### DOCKER_CONTAINER #########################################################

  describe docker_container(ENV["LOGSTASH_CONTAINER"]) do
    it { is_expected.to be_running }
  end

  ### LOGSTASH_ENDPOINT ########################################################

  describe host(hostname) do
    it { is_expected.to be_reachable.with(:port => port, :proto => "udp", :timeout => 1) }
    it { is_expected.to be_reachable.with(:port => port, :proto => "tcp", :timeout => 1) }
  end

  ##############################################################################

end
