class BusstopNode
	attr_accessor :id, :neighbours, :busstop
	@@graph = Array.new
	def initialize(id = 0, *neighbour)
		@busstop = Busstop.new
		@id = -1
		if not @id == 0
			@id = id			
		end
		@neighbours = Array.new
		neighbour.each do |n|
			@neighbours << n
		end
	end
	def self.graph
		@@graph
	end
	def self.addToGraph(data)
		@@graph << data
	end
	def self.printGraph
		@@graph.each do |node|
			print "Node id ==> #{node.id} ==> "
			node.neighbours.each do |neighbour|
				print "[#{ObjectSpace._id2ref(neighbour).id}]"
			end
			print "\n"
		end
	end

	def getBusstop(id)
		@id = id
		return @busstop = Busstop.find(id)
	end

	def self.createGraph
		allBusstops = Busstop.all
		allBusstops.each do |currentBusstop|
			
			#sleep(3)
			@@graph << newNode = BusstopNode.new
			newNode.busstop = currentBusstop
			newNode.id = currentBusstop.id
			print "\nNode ID: #{newNode.id}\nNode Object_ID: #{newNode.object_id}"
			#Assigning Neighbours
		end

		print "\nInitial Nodes Created\n\n"

		@@graph.each do |newNode|
			print "\n\nStarting New Busstop Iteration\n\n\nEnter To Start:"
			gets()
			currentBusstop = newNode.busstop


			routesForBusstop = currentBusstop.routes
			routesForBusstop.each do |currentRoute|
				relationForSequence = RouteBusstop.where(:busstop_id => currentBusstop.id, :route_id => currentRoute.id)
				if relationForSequence.second.blank?
					print "\nNo Second Object found. Valid Yet\n\n"
					currentBusstopSequenceNumber = relationForSequence.first.busStopSequenceNumber
					print "\nValue for currentBusstopSequenceNumber ==> #{currentBusstopSequenceNumber}\n\n"
					nextBusstopSequenceNumber = currentBusstopSequenceNumber + 1
					previousBusstopSequenceNumber = currentBusstopSequenceNumber - 1
					if not(Route.find(currentRoute.id).busstops.count <= currentBusstopSequenceNumber)
						newNode.neighbours << self.findBusstopFromGraph(self.findNeighbourBusstop(currentRoute.id, currentBusstopSequenceNumber + 1)).object_id
					end
					
					if not (currentBusstopSequenceNumber == 1)
						newNode.neighbours << self.findBusstopFromGraph(self.findNeighbourBusstop(currentRoute.id, currentBusstopSequenceNumber - 1)).object_id

					end
					
					#Find the Busstop ==> relationForNeighbourBusstops.first.busstop_id from the graph array.
					#get the object_id for this  busstop and push it to newNode.neighbour.
					
				end

			end
			self.displayNode(newNode)
		end
		return @@graph
	end

	def self.findBusstopFromGraph(busstop_id)
		foundBusstopCount = 0
		@@graph.each do |node|
			if node.id == busstop_id
				print "Node Found From Graph for next Busstop"
				return node
			end
			
		end
	end

	def self.displayNode(newNode)
		print "\n\nPrinting Node Properties\n\n"
		print "\tNode ID = #{newNode.id}\n"
		print "\tNode Object_ID = #{newNode.object_id}\n"

		print "\tNode BusstopName = #{newNode.busstop.busStopName}\n"
		print "\tNode Neighbours ==> #{newNode.neighbours}"
		# newNode.neighbours.each do |neighbour|
		# 	print "#{neighbour}\n"
		# end
		# print "\n]"
		
	end

	def self.findNeighbourBusstop(route_id = 0, busStopSequenceNumber = 0)
		relationForNeighbourBusstops = RouteBusstop.where(:route_id => route_id, :busStopSequenceNumber => busStopSequenceNumber)
		print "\ncount for relationForNeighbourBusstops ==> #{relationForNeighbourBusstops.count}\n\n"
		print "\nRelation RouteBusstop For nextBusstopSequenceNumber ==> #{relationForNeighbourBusstops.first.to_yaml}\n\n"
		if not relationForNeighbourBusstops.blank?
			nextBusstopToCurrentBusstop = Busstop.find(relationForNeighbourBusstops.first.busstop_id)
			print "\n\nNeighbour Busstop to currentBusstop ==> #{nextBusstopToCurrentBusstop.to_yaml}\n\n"
			return nextBusstopToCurrentBusstop.id
		end
		
	end

	def self.validateGraph(graph = [])
		flag = true
		objectIDArray = Array.new
		graph.each do |node|
			objectIDArray << node.object_id
		end
		trueCount = 0
		graph.each do |node|
			node.neighbours.each do |neighbour|
				objectIDArray.each do |object_id|
					if neighbour == object_id
						trueCount  = trueCount + 1
					end
				end
				if trueCount > 1 or trueCount < 1
					flag =  false
				end
				trueCount = 0
			end
		end
		return flag
	end
end