<?php

namespace Console;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;

class BuildCommand extends Command
{

    public function __construct()
    {
        parent::__construct();
    }

    public function configure()
    {
        $this -> setName('build')
            -> setDescription('Build satis server.')
            -> setHelp('todo');
            //-> addArgument('ref', InputArgument::REQUIRED, 'Tag or branch of GovCMS.');
    }

    public function execute(InputInterface $input, OutputInterface $output)
    {
        $working_dir = sys_get_temp_dir() . '/build-satis-' . mt_rand(0, 9999999);
        $ref = '1.1.1';
        $output->writeln($working_dir);
        $process = new Process(['git', 'clone', 'https://github.com/govCMS/govCMS8.git', "--branch=$ref", '--depth=1', $working_dir]);
        $process->run();

        $process = new Process(['git', 'clone', 'https://github.com/govCMS/govCMS8.git', "--branch=$ref", '--depth=1', $working_dir]);


        $lock_file = json_decode(file_get_contents($working_dir . '/composer.lock'), TRUE);

        foreach ($lock_file['packages'] as $package) {
            $output->writeln($package['name'] . '--' . implode(',', array_keys($package)));
        }



// executes after the command finishes
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        echo $process->getOutput();

        return 0;
    }

}
