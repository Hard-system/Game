
# Main class module
module OXs_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	GOES = 12

	COLOURS = "RGBP"
	
	class Game
		attr_reader :table, :input, :output, :turn, :turnsleft, :winner, :secret, :score, :resulta, :resultb, :guess
		attr_writer :table, :input, :output, :turn, :turnsleft, :winner, :secret, :score, :resulta, :resultb, :guess
		
		def initialize(input, output)
			@input = input
			@output = output
			@turnsleft = GOES
			 # @resulta[0] = GOES
			# @resultb[0] = @score
		end
		
		def getguess
			guess = @input.gets.chomp.upcase
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added below.
		
		def start
			@output.puts("Welcome to Mastermind!")
			@output.puts("Created by: #{created_by} (#{student_id})")
			@output.puts("Starting game...")
			@output.puts("The game has 12 turns!")
			@secret = "XXXX"
			valid1 = checksecret(secret)
		end

		def created_by
			@game = "Miroslav Stoyanov"
		end

		def student_id
			@game = 51663927
		end

		def displaymenu
			@output.puts("Menu: (1) Start | (2) New | (3) Analysis | (9) Exit")
		end

		def clearwinner
			@winner = 0
		end

		def setturn(turn)
			@turn = turn
		end

		def setturnsleft(goes)
			@turnsleft
		end

		def checksecret(secret)
			valid=0
			if secret.length == 4
				for i in 0..3
					if secret[i] != "R" && secret[i]!= "G" && secret[i] != "B" && secret[i] != "P" 
						valid = 1
						break
					end
				i += 1
				end
			else
				valid = 1
			end
			valid
	
		end
	
		def gensecret(secret)
			secret = "RGBP"
   		@secret = (0...secret.length).map { |i| secret[rand(4)] }.join('')
   			
		end
		
		def setsecret(secret)
			@secret = secret
		end

		def getsecret 
			@secret
		end

		def displaysecret
			secret = "XXXX"
			@output.puts ("Secret state: #{secret}")
		end

		def gettableturnvalue(turn)
			@table[turn]
		end

		def settableturnvalue(turn, value)
			@table[turn] = value
		end

		def cleartable
			
			@table = ["____","____","____","____","____","____","____","____","____","____","____","____"]
			@winner = 0
			@resulta = [0] * GOES
			@resultb = [0] * GOES
		end

		def displaytable
			@output.puts("TURN | XXXX | SCORE\n===================\n  1. | #{gettableturnvalue(0)} |\n  2. | #{gettableturnvalue(1)} |    \n  3. | #{gettableturnvalue(2)} |    \n  4. | #{gettableturnvalue(3)} |    \n  5. | #{gettableturnvalue(4)} |    \n  6. | #{gettableturnvalue(5)} |    \n  7. | #{gettableturnvalue(6)} |    \n  8. | #{gettableturnvalue(7)} |    \n  9. | #{gettableturnvalue(8)} |    \n 10. | #{gettableturnvalue(9)} |     \n 11. | #{gettableturnvalue(10)} |    \n 12. | #{gettableturnvalue(11)} |    \n\n")
			@output.puts("Enter what you thing the secret code is. 'Enter' returns to menu!")
		end

		def finish
			@output.puts('...finished game')
		end

		def checkresult(turn)
			score1 = 0
			score2 = 0
			secret = @secret.scan(/\w/)
			guess = @table[turn].scan(/\w/)

			secret.zip(guess).each do |secret_digit, guess_digit|
				if secret_digit == guess_digit
					score2 += 1
				end
			end

			s = 0
			for digit in guess.uniq
				s += [guess.count(digit), secret.count(digit)].min
			end

			score1 = s - score2

			@score = "#{score2}:#{score1}"
		end



		def displayanalysis

			@output.puts("TURN | XXXX | SCORE\n===================\n  1. | #{gettableturnvalue(0)} | #{checkresult(0)}\n  2. | #{gettableturnvalue(1)} | #{checkresult(1)}\n  3. | #{gettableturnvalue(2)} | #{checkresult(2)}\n  4. | #{gettableturnvalue(3)} | #{checkresult(3)}\n  5. | #{gettableturnvalue(4)} | #{checkresult(4)}\n  6. | #{gettableturnvalue(5)} | #{checkresult(5)}\n  7. | #{gettableturnvalue(6)} | #{checkresult(6)}\n  8. | #{gettableturnvalue(7)} | #{checkresult(7)}\n  9. | #{gettableturnvalue(8)} | #{checkresult(8)}\n 10. | #{gettableturnvalue(9)} | #{checkresult(9)}\n 11. | #{gettableturnvalue(10)} | #{checkresult(10)}\n 12. | #{gettableturnvalue(11)} | #{checkresult(11)}\n\n")
				
		end

		def revealtable
			@output.puts("TURN | #{@secret} | SCORE\n===================\n  1. | ____ |\n  2. | ____ |\n  3. | ____ |\n  4. | ____ |\n  5. | ____ |\n  6. | ____ |\n  7. | ____ |\n  8. | ____ |\n  9. | ____ |\n 10. | ____ |\n 11. | ____ |\n 12. | ____ |\n\n")
		end

		# Any code/methods aimed at passing the RSpect tests should be added above.

		# def readFile(func)
		# 	file = File.open(func, "r")
		# 	@content = file.read
		# 	file.close
		# end

		def recordAnalysis(filename)
			file = File.open(filename, "a")
            timenow = Time.now.asctime
            # file.puts @resulta
            file.puts @score
            file.puts @table
            file.puts @turn
            file.puts @turnsleft
            file.puts secret
            file.close  
            
        end
	end

end

