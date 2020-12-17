local cmd = vim.cmd

-- I am slow on the shift key
cmd('abbrev willREturn willReturn')
cmd('abbrev shouldREturn shouldReturn')

cmd('abbrev willTHrow willThrow')

cmd('abbrev sectino section')

cmd('abbrev colleciton collection')
cmd('abbrev Colleciton Collection')

cmd('abbrev conneciton connection')
cmd('abbrev Conneciton Connection')

cmd('abbrev connecitno connection')
cmd('abbrev Connecitno Connection')

cmd('abbrev leagcy legacy')
cmd('abbrev Leagcy Legacy')

cmd("cabbr <expr> %% expand('%:p:h')") -- in ex mode %% is current dir
