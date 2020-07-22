<?php

class CouchbaseViewQuery
{
    const UPDATE_BEFORE = 1;
    const UPDATE_NONE = 2;
    const UPDATE_AFTER = 3;
    const ORDER_ASCENDING = 1;
    const ORDER_DESCENDING = 2;
    public $ddoc = '';
    public $name = '';
    public $options = array();
    private function __construct()
    {
    }
    public static function from($ddoc, $name)
    {
    }
    public static function fromSpatial($ddoc, $name)
    {
    }
    public function stale($stale)
    {
    }
    public function skip($skip)
    {
    }
    public function limit($limit)
    {
    }
    public function custom($opts)
    {
    }
    public function _toString($type)
    {
    }
}

class CouchbaseN1qlQuery
{
    const NOT_BOUNDED = 1;
    const REQUEST_PLUS = 2;
    const STATEMENT_PLUS = 3;
    public $options = array();
    public static function fromString($str)
    {
    }
    public function positionalParams($params)
    {
    }
    public function namedParams($params)
    {
    }
    public function consistency($consistency)
    {
    }
    public function consistentWith($mutationState)
    {
    }
    public function adhoc($adhoc)
    {
    }
    public function toObject()
    {
    }
    public function toString()
    {
    }
}

class CouchbaseSearchQuery
{
    private $indexName = null;
    private $queryPart = null;
    private $limit = null;
    private $skip = null;
    private $explain = null;
    private $highlightStyle = null;
    private $highlightFields = null;
    private $serverSideTimeout = null;
    private $mutationState = null;
    private $fields = null;
    private $facets = array();
    public function __construct($indexName, $queryPart)
    {
    }
    public function limit($limit)
    {
    }
    public function skip($skip)
    {
    }
    public function explain($explain)
    {
    }
    public function highlight($style, $fields = array())
    {
    }
    public function fields($fields = null)
    {
    }
    public function serverSideTimeout($timeout)
    {
    }
    public function addFacet($facetName, $facet)
    {
    }
    public function clearFacets()
    {
    }
    public function consistentWith($mutationState)
    {
    }
    public function export()
    {
    }
    public function injectParams(&$input)
    {
    }
    public static function string($query)
    {
    }
    public static function match($match)
    {
    }
    public static function matchPhrase($matchPhrase)
    {
    }
    public static function prefix($prefix)
    {
    }
    public static function regexp($regexp)
    {
    }
    public static function numericRange()
    {
    }
    public static function dateRange()
    {
    }
    public static function disjuncts($queries = array())
    {
    }
    public static function conjuncts($queries = array())
    {
    }
    public static function booleans()
    {
    }
    public static function wildcard($wildcard)
    {
    }
    public static function docId($docIds = array())
    {
    }
    public static function booleanField($value)
    {
    }
    public static function term($term)
    {
    }
    public static function phrase($terms)
    {
    }
    public static function matchAll()
    {
    }
    public static function matchNone()
    {
    }
}

class CouchbaseAbstractSearchQuery
{
    private $boost = null;
    protected function __construct()
    {
    }
    public function boost($boost)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseStringSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $query = null;
    public function __construct($query)
    {
    }
    public function boost($boost)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseMatchSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $match = null;
    private $field = null;
    private $analyzer = null;
    private $prefixLength = null;
    private $fuzziness = null;
    public function __construct($match)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function analyzer($analyzer)
    {
    }
    public function prefixLength($prefixLength)
    {
    }
    public function fuzziness($fuzziness)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseTermSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $term = null;
    private $field = null;
    private $prefixLength = null;
    private $fuzziness = null;
    public function __construct($term)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function prefixLength($prefixLength)
    {
    }
    public function fuzziness($fuzziness)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbasePhraseSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $terms = null;
    private $field = null;
    public function __construct($terms = array())
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseMatchPhraseSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $matchPhrase = null;
    private $field = null;
    private $analyzer = null;
    public function __construct($matchPhrase)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function analyzer($analyzer)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbasePrefixSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $prefix = null;
    private $field = null;
    public function __construct($prefix)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseRegexpSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $regexp = null;
    private $field = null;
    public function __construct($regexp)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseWildcardSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $wildcard = null;
    private $field = null;
    public function __construct($wildcard)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseBooleanFieldSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $value = null;
    private $field = null;
    public function __construct($value)
    {
    }
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseDocIdSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $docIds = null;
    public function __construct($docIds = array())
    {
    }
    public function boost($boost)
    {
    }
    public function docIds($docIds)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseMatchAllSearchQuery extends \CouchbaseAbstractSearchQuery
{
    public function boost($boost)
    {
    }
    public function injectParams(&$input)
    {
    }
    protected function __construct()
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseMatchNoneSearchQuery extends \CouchbaseAbstractSearchQuery
{
    public function boost($boost)
    {
    }
    public function injectParams(&$input)
    {
    }
    protected function __construct()
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseNumericRangeSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $min = null;
    private $max = null;
    private $inclusiveMin = null;
    private $inclusiveMax = null;
    private $field = null;
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function min($min, $inclusive = true)
    {
    }
    public function max($max, $inclusive = false)
    {
    }
    public function injectParams(&$input)
    {
    }
    protected function __construct()
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseDateRangeSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $start = null;
    private $end = null;
    private $inclusiveStart = null;
    private $inclusiveEnd = null;
    private $dateTimeParser = null;
    private $field = null;
    public function boost($boost)
    {
    }
    public function field($field)
    {
    }
    public function start($start, $inclusive = true)
    {
    }
    public function end($end, $inclusive = false)
    {
    }
    public function dateTimeParser($parser)
    {
    }
    public function injectParams(&$input)
    {
    }
    protected function __construct()
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseAbstractCompoundSearchQuery extends \CouchbaseAbstractSearchQuery
{
    protected $childQueries = null;
    protected function __construct($childQueries)
    {
    }
    protected function addAll($queries)
    {
    }
    public function boost($boost)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseDisjunctionSearchQuery extends \CouchbaseAbstractCompoundSearchQuery
{
    private $min = null;
    protected $childQueries = null;
    public function __construct($queries = array())
    {
    }
    public function boost($boost)
    {
    }
    public function min($min)
    {
    }
    public function either($queries)
    {
    }
    public function injectParams(&$input)
    {
    }
    protected function addAll($queries)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseConjunctionSearchQuery extends \CouchbaseAbstractCompoundSearchQuery
{
    protected $childQueries = null;
    public function __construct($queries = array())
    {
    }
    public function boost($boost)
    {
    }
    public function every($queries)
    {
    }
    public function injectParams(&$input)
    {
    }
    protected function addAll($queries)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseBooleanSearchQuery extends \CouchbaseAbstractSearchQuery
{
    private $must = null;
    private $mustNot = null;
    private $should = null;
    public function __construct()
    {
    }
    public function boost($boost)
    {
    }
    public function shouldMin($minForShould)
    {
    }
    public function must($mustQueries)
    {
    }
    public function mustNot($mustNotQueries)
    {
    }
    public function should($shouldQueries)
    {
    }
    public function injectParams(&$input)
    {
    }
    public function injectParamsAndBoost(&$input)
    {
    }
}

class CouchbaseSearchFacet
{
    private $field = null;
    private $limit = null;
    protected function __construct($field, $limit)
    {
    }
    public function injectParams(&$input)
    {
    }
    public static function term($field, $limit)
    {
    }
    public static function numeric($field, $limit)
    {
    }
    public static function dataRange($field, $limit)
    {
    }
}

class CouchbaseTermSearchFacet extends \CouchbaseSearchFacet
{
    public function __construct($field, $limit)
    {
    }
    public function injectParams(&$input)
    {
    }
    public static function term($field, $limit)
    {
    }
    public static function numeric($field, $limit)
    {
    }
    public static function dataRange($field, $limit)
    {
    }
}

class CouchbaseDateRangeSearchFacet extends \CouchbaseSearchFacet
{
    private $dateRanges = null;
    public function __construct($field, $limit)
    {
    }
    public function addRange($rangeName, $start, $end)
    {
    }
    public function injectParams(&$input)
    {
    }
    public static function term($field, $limit)
    {
    }
    public static function numeric($field, $limit)
    {
    }
    public static function dataRange($field, $limit)
    {
    }
}

class CouchbaseNumericRangeSearchFacet extends \CouchbaseSearchFacet
{
    private $numericRanges = null;
    public function __construct($field, $limit)
    {
    }
    public function addRange($rangeName, $min, $max)
    {
    }
    public function injectParams(&$input)
    {
    }
    public static function term($field, $limit)
    {
    }
    public static function numeric($field, $limit)
    {
    }
    public static function dataRange($field, $limit)
    {
    }
}

class CouchbaseCluster
{
    private $_manager = null;
    private $_dsn = null;
    private $authenticator = null;
    public function __construct($connstr = 'http://127.0.0.1/', $username = '', $password = '')
    {
    }
    public function authenticate($authenticator)
    {
    }
    public function openBucket($name = 'default', $password = '')
    {
    }
    public function manager($username = '', $password = '')
    {
    }
}

class CouchbaseAuthenticator
{
    private $adminUsername = null;
    private $adminPassword = null;
    private $buckets = array();
    public function setBucketCredentials($bucketName, $password)
    {
    }
    public function setClusterCredentials($username, $password)
    {
    }
    public function getCredentials($context, $specific = null)
    {
    }
}

class CouchbaseClusterManager
{
    private $_me = null;
    public function __construct($connstr, $username, $password)
    {
    }
    public function listBuckets()
    {
    }
    public function createBucket($name, $opts = array())
    {
    }
    public function removeBucket($name)
    {
    }
    public function info()
    {
    }
}

class CouchbaseBucket
{
    private $me = null;
    private $name = null;
    private $_manager = null;
    private $queryhosts = null;
    private $authenticator = null;
    public function __construct($connstr, $name, $password, $authenticator = null)
    {
    }
    public function getName()
    {
    }
    public function manager()
    {
    }
    public function enableN1ql($hosts)
    {
    }
    public function insert($ids, $val = null, $options = array())
    {
    }
    public function upsert($ids, $val = null, $options = array())
    {
    }
    public function replace($ids, $val = null, $options = array())
    {
    }
    public function append($ids, $val = null, $options = array())
    {
    }
    public function prepend($ids, $val = null, $options = array())
    {
    }
    public function remove($ids, $options = array())
    {
    }
    public function get($ids, $options = array())
    {
    }
    public function getAndTouch($id, $expiry, $options = array())
    {
    }
    public function getAndLock($id, $lockTime, $options = array())
    {
    }
    public function getFromReplica($id, $options = array())
    {
    }
    public function touch($id, $expiry, $options = array())
    {
    }
    public function counter($ids, $delta, $options = array())
    {
    }
    public function unlock($ids, $options = array())
    {
    }
    public function _view($queryObj, $json_asarray)
    {
    }
    public function _n1ql($queryObj, $json_asarray)
    {
    }
    public function _search($queryObj, $json_asarray)
    {
    }
    public function query($query, $json_asarray = false)
    {
    }
    public function lookupIn($id)
    {
    }
    public function retrieveIn($id)
    {
    }
    public function mutateIn($id, $cas = null)
    {
    }
    public function _subdoc($id, $commands, $cas = null)
    {
    }
    public function setTranscoder($encoder, $decoder)
    {
    }
    private function _endure($id, $options, $res)
    {
    }
    public function __get($name)
    {
    }
    public function __set($name, $value)
    {
    }
}

class CouchbaseMutationState
{
    private $tokens = array();
    public static function from($source = array())
    {
    }
    public function add($source = array())
    {
    }
    public function exportForN1ql()
    {
    }
    public function exportForSearch()
    {
    }
    private function addToken($newToken)
    {
    }
}

class CouchbaseBucketManager
{
    private $_me = null;
    private $_name = null;
    public function __construct($binding, $name)
    {
    }
    public function getDesignDocuments()
    {
    }
    public function insertDesignDocument($name, $data)
    {
    }
    public function upsertDesignDocument($name, $data)
    {
    }
    public function getDesignDocument($name)
    {
    }
    public function removeDesignDocument($name)
    {
    }
    public function listN1qlIndexes()
    {
    }
    public function createN1qlPrimaryIndex($customName = '', $ignoreIfExist = false, $defer = false)
    {
    }
    public function createN1qlIndex($indexName, $fields, $whereClause = '', $ignoreIfExist = false, $defer = false)
    {
    }
    public function dropN1qlPrimaryIndex($customName = '', $ignoreIfNotExist = false)
    {
    }
    public function dropN1qlIndex($indexName, $ignoreIfNotExist = false)
    {
    }
    public function flush()
    {
    }
    public function info()
    {
    }
}

class CouchbaseMutateInBuilder
{
    public $id = null;
    public $cas = null;
    private $commands = array();
    private $bucket = null;
    public function __construct($bucket, $id, $cas)
    {
    }
    public function insert($path, $value, $createParents = false)
    {
    }
    public function upsert($path, $value, $createParents = false)
    {
    }
    public function replace($path, $value)
    {
    }
    public function remove($path)
    {
    }
    public function arrayPrepend($path, $value, $createParents = false)
    {
    }
    public function arrayAppend($path, $value, $createParents = false)
    {
    }
    public function arrayInsert($path, $value)
    {
    }
    public function arrayPrependAll($path, $values, $createParents = false)
    {
    }
    public function arrayAppendAll($path, $values, $createParents = false)
    {
    }
    public function arrayInsertAll($path, $values)
    {
    }
    public function arrayAddUnique($path, $value, $createParents = false)
    {
    }
    public function counter($path, $delta, $createParents = false)
    {
    }
    public function execute()
    {
    }
}

class CouchbaseLookupInBuilder
{
    public $id = null;
    private $commands = array();
    private $bucket = null;
    public function __construct($bucket, $id)
    {
    }
    public function get($path)
    {
    }
    public function exists($path)
    {
    }
    public function execute()
    {
    }
}

class CouchbaseAuthenticator
{
    private $adminUsername = null;
    private $adminPassword = null;
    private $buckets = array();
    public function setBucketCredentials($bucketName, $password)
    {
    }
    public function setClusterCredentials($username, $password)
    {
    }
    public function getCredentials($context, $specific = null)
    {
    }
}

class CouchbaseSearchFacet
{
    private $field = null;
    private $limit = null;
    protected function __construct($field, $limit)
    {
    }
    public function injectParams(&$input)
    {
    }
    public static function term($field, $limit)
    {
    }
    public static function numeric($field, $limit)
    {
    }
    public static function dataRange($field, $limit)
    {
    }
}
