require 'pry'
require 'curb'
require 'json'
require 'active_support/all'
require 'dotenv'
Dotenv.load

class StudentRandomizer
	attr_accessor :course_id, :number_random_picks, :random_students
	CANVAS_BASE_URL = 'https://canvas.devpointlabs.com/api/v1'
	ACCESS_TOKEN = ENV['CANVAS_API_TOKEN']

	def initialize
		puts 'What is the course Id?'
		@course_id = gets.to_i
		puts 'How many random students do you want to pick?'
		@number_random_picks = gets.to_i
		@random_students = []
		randomize(course_id)
		puts @random_students
	end

	def pick_students(students)
		picked_student = students.sample
		random_students << picked_student unless random_students.include?(picked_student)
		pick_students(students) unless random_students.length == number_random_picks
	end

	def randomize(course_id)
		http = Curl.get(CANVAS_BASE_URL + "/courses/#{course_id}/users?enrollment_type[]=student&per_page=30") do |http|
		  http.headers['Authorization'] = "Bearer #{ACCESS_TOKEN}"
		end
	  pick_students(JSON.parse(http.body_str).map{|student| student['name']})
	end
end

StudentRandomizer.new
