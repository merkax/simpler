require_relative 'config/environment'

use Simpler::SimplerLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
