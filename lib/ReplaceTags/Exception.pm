package ReplaceTags::Exception;
use Moose;
extends 'Throwable::Error';
no Moose;

package ReplaceTags::Exception::FileIO;
use Moose;
extends 'ReplaceTags::Exception';
no Moose;

package ReplaceTags::Exception::ArgumentMissing;
use Moose;
extends 'ReplaceTags::Exception';
no Moose;

package ReplaceTags::Exception::DirDoesNotExist;
use Moose;
extends 'ReplaceTags::Exception';
no Moose;

package ReplaceTags::Exception::FileDoesNotExist;
use Moose;
extends 'ReplaceTags::Exception';
no Moose;
