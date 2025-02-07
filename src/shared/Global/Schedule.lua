type Job = (...any) -> ()

type JobData = {
	Job: Job,
	RunAfter: Job?,
	Order: number,
}

type Jobs = {
	[Job]: JobData,
}

type SortedJobData = {
	Job: Job,
	JobsToRun: { Job },
	Order: number,
}

type SortedJobs = {
	[Job]: SortedJobData,
}

-- Now we handle the jobs
local Schedule = {}
local Jobs: Jobs = {}

local CompletedJobs: { [Job]: boolean } = {}

local function BiggestJobOrder(): number
	local Order = 0

	for _, Job in Jobs do
		if Job.Order == Order then
			continue
		end
		Order = Job.Order
	end

	return Order
end

local function RunJobs(Job: SortedJobData)
	if not CompletedJobs[Job.Job] then
		task.spawn(Job.Job)
		CompletedJobs[Job.Job] = true
	end

	if #Job.JobsToRun <= 0 then
		return
	end

	for _, ToRun in ipairs(Job.JobsToRun) do
		if CompletedJobs[ToRun] then
			continue
		end

		task.spawn(ToRun)
		CompletedJobs[ToRun] = true
	end
end

local function Sort(): SortedJobData
	local SortedJobs = {}

	for _, Job in Jobs do
		if Job.RunAfter then
			if not SortedJobs[Job.RunAfter] then
				SortedJobs[Job.RunAfter] = {
					Job = Job.RunAfter,
					JobsToRun = {}, -- Only this will get this!
					Order = Jobs[Job.RunAfter].Order,
				}
			end

			local SortedAfter = SortedJobs[Job.RunAfter]
			table.insert(SortedAfter.JobsToRun, Job.Job)
		else
			if SortedJobs[Job.Job] then
				continue
			end

			SortedJobs[Job.Job] = {
				Job = Job.Job,
				JobsToRun = {},
				Order = Job.Order,
			}
		end
	end

	for _, Job in SortedJobs do
		local OurJob = Jobs[Job.Job]

		if not OurJob.RunAfter then
			continue
		end
		if #Job.JobsToRun <= 0 then
			continue
		end

		table.insert(SortedJobs[OurJob.RunAfter].JobsToRun, Job.Job)

		for _, NewJob in Job.JobsToRun do
			table.insert(SortedJobs[OurJob.RunAfter].JobsToRun, NewJob)
		end

		SortedJobs[Job.Job] = nil
	end

	return SortedJobs
end

function Schedule:Add(Job: Job, RunAfter: Job?)
	Jobs[Job] = {
		Job = Job,
		RunAfter = RunAfter,
		Order = BiggestJobOrder() + 1,
	}

	return Job
end

function Schedule:Boot()
	local SortedJobs: SortedJobs = Sort()

	for _, Job in SortedJobs do
		RunJobs(Job)
	end
end

return Schedule
