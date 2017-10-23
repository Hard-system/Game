# Ruby assignment
# Change the following tests with your own name and student ID.
# NB. Failure to do so will result in marks being deducted.
# IMPORTANT: Ensure you save the file after making the changes. 
# DO notchange the names of the files. Just ensure you backup the files often.

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_mastermind_gen_01"

# predefined method - NOT to be removed
def check_valid(secret)
	@game.secret = secret
	sarray = []
	i = 0
	secret.split('').each do|c| 
		sarray[i] = c
		i=i+1
	end
	i = 0
	valid = 0
	if sarray[i] != "R" && sarray[i]!= "G" && sarray[i] != "B" && sarray[i] != "P" 
		valid = 1
	end
	if sarray[i+1] != "R" && sarray[i+1] != "G" && sarray[i+1] != "B" && sarray[i+1] != "P"
		valid = 1
	end
	if sarray[i+2] != "R" && sarray[i+2] != "G" && sarray[i+2] != "B" && sarray[i+2] != "P"
		valid = 1
	end
	if sarray[i+3] != "R" && sarray[i+3] != "G" && sarray[i+3] != "B" && sarray[i+3] != "P"
		valid = 1
	end
	valid
end

module OXs_Game
	# RSpec Tests 
	describe Game do
		describe "#Mastermind game" do
			before(:each) do
				@input = double('input').as_null_object
				@output = double('output').as_null_object
				@game = Game.new(@input, @output)
			end
			it "should display a welcome message within start" do
				@output.should_receive(:puts).with('Welcome to Mastermind!')
				@game.start
			end
			it "should contain a method created_by which returns the students name" do
				myname = @game.created_by
				myname.should == "Miroslav Stoyanov"	# -----Change text to your own name-----
			end
			it "should contain a method student_id which returns the students ID number" do
				studentid = @game.student_id
				studentid.should == 51663927		# -----Change ID to your own student ID number-----
			end
			it "should display a created by message within start" do
				@output.should_receive(:puts).with("Created by: #{@game.created_by} (#{@game.student_id})")
				@game.start
			end
			it "should display a starting message within start" do
				@output.should_receive(:puts).with('Starting game...')
				@game.start			
			end
			it "should show message to prompt which version to run within start" do
				@output.should_receive(:puts).with('Enter "1" to run the game in the command-line window or "2" to run it in a web browser')
				@game.start			
			end
			it "should display menu" do
				@output.should_receive(:puts).with("Menu: (1) Start | (2) New | (3) Analysis | (9) Exit")
				@game.displaymenu
			end
			it "should set winner to zero" do
				winner = 0
				@game.clearwinner
				@game.winner.should eql 0
			end
			it "should set turn to zero" do
				turn = 0
				@game.setturn(turn)
				@game.turn.should eql turn
			end
			it "should set turnsleft to 12" do
				goes = 12
				@game.setturnsleft(goes)
				@game.turnsleft.should eql goes
			end
			it "should validate secret contains four accepted uppercase characters" do
				@game.secret = "XXXX"
				secret = "RRRR"
				valid1 = @game.checksecret(secret)
				valid2 = check_valid(secret)
				valid1.should == valid2 && @game.secret.should == secret && valid1.should == 0
			end
			it "should randomly generate a valid secret string four uppercase characters long from a set of four characters representing colours" do
				secret = @game.gensecret("RGBP")
				@game.secret = "XXXX"
				valid1 = @game.checksecret(secret)
				valid2 = check_valid(secret)
				valid1.should == valid2 && @game.secret.should == secret && valid1.should == 0
			end
			it "should set secret" do
				secret = "RRRR"
				@game.setsecret(secret)
				@game.secret.should eql secret
			end
			it "should get secret" do
				secret = "RRRR"
				@game.setsecret(secret)
				@game.getsecret.should eql secret
			end
			it "should display secret state" do
				secret = "XXXX"
				@game.setsecret(secret)
				@output.should_receive(:puts).with("Secret state: #{secret}")
				@game.displaysecret
			end
			it "should clear table" do
				table = ["____","____","____","____","____","____","____","____","____","____","____","____"]
				@game.cleartable
				@game.table.should == table && @game.winner.should == 0
			end
			it "should get table turn values" do
				@game.cleartable
				turn = 0
				value = @game.gettableturnvalue(turn)
				value.should == "____"
			end
			it "should set a table turn value to a valid guess" do
				turn = 0
				value = "RRRR"
				@game.cleartable
				@game.settableturnvalue(turn,  value)
				@game.table[turn].should == value				
			end
			it "should display current state of table" do
				turn = 0
				value = "RRRR"
				@game.cleartable
				@game.settableturnvalue(turn,  value)
				@output.should_receive(:puts).with("TURN | XXXX | SCORE\n===================\n  1. | #{@game.table[turn]} |\n  2. | ____ |\n  3. | ____ |\n  4. | ____ |\n  5. | ____ |\n  6. | ____ |\n  7. | ____ |\n  8. | ____ |\n  9. | ____ |\n 10. | ____ |\n 11. | ____ |\n 12. | ____ |\n\n")
				@game.displaytable
			end
			it "should send a finish message" do
				@output.should_receive(:puts).with('...finished game')
				@game.finish			
			end
			it "should check whether guess correct and displaying score" do
				turn = 0
				secret = "RRRP"
				@game.setsecret(secret)
				value = "RRRR"
				@game.cleartable
				@game.settableturnvalue(turn,  value)
				@output.should_receive(:puts).with("Result 3:0")
				@game.checkresult(turn)
			end
			it "should display analysis" do
				turn = 0
				secret = "RRRP"
				@game.setsecret(secret)
				value = "RRRR"
				@game.cleartable
				@game.settableturnvalue(turn,  value)
				@output.should_receive(:puts).with("TURN | XXXX | SCORE\n===================\n  1. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  2. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  3. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  4. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  5. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  6. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  7. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  8. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n  9. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n 10. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n 11. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n 12. | #{@game.table[turn]} | #{@game.resulta[turn]}:#{@game.resultb[turn]}\n\n")
				@game.displayanalysis
			end
			it "should display table revealing randomly generated secret" do
				@game.cleartable
				secret = @game.gensecret("RGBP")
				@game.setsecret(secret)
				@output.should_receive(:puts).with("TURN | #{secret} | SCORE\n===================\n  1. | ____ |\n  2. | ____ |\n  3. | ____ |\n  4. | ____ |\n  5. | ____ |\n  6. | ____ |\n  7. | ____ |\n  8. | ____ |\n  9. | ____ |\n 10. | ____ |\n 11. | ____ |\n 12. | ____ |\n\n")
				@game.revealtable
			end

		end
	end
end