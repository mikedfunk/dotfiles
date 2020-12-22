Vim�UnDo� ���gfF�A��P�E��Ul�q���nC�3��     <?php                              _ڂ�     _�                             ����                                                                                                                                                                                                                                                                                                                �   :                                        _�i�     �         �      <?php5�_�                    �        ����                                                                                                                                                                                                                                                                                                                �   :                                        _ڂ�     �               <?php�              �   <?php       declare(strict_types=1);       "namespace Palette\SaatchiArt\User;       7use Illuminate\Validation\Factory as ValidationFactory;   Euse Palette\Adapters\Repositories\Algolia\LegacyCollectionRepository;   Muse Palette\Adapters\Repositories\ArtworkRepository as CoreArtworkRepository;   Vuse Palette\Adapters\Repositories\Legacy\ArtworkRepository as LegacyArtworkRepository;   Puse Palette\Adapters\Repositories\Legacy\UserRepository as LegacyUserRepository;   ?use Palette\Adapters\Repositories\Legacy\UserSessionRepository;   1use Palette\Adapters\Repositories\UserRepository;   Fuse Palette\SaatchiArt\Artist\Payout\HyperwalletPayoutUserCredentials;   =use Palette\SaatchiArt\Artist\Payout\PayoutProviderInterface;   'use Palette\SaatchiArt\Artwork\Artwork;   -use Palette\SaatchiArt\Artwork\ImageUploader;   6use Palette\SaatchiArt\Exceptions\CreateUserException;   8use Palette\SaatchiArt\Exceptions\UserNotFoundException;   Ause Palette\SaatchiArt\Exceptions\UserNotVerifiedToSellException;   3use Palette\SaatchiArt\Ports\VatValidatorInterface;   use Palette\UserType;       class UserService   {       /**   /     * Rebecca Wilson's user id (chief curator)        *        * @access private        */   +    const DEFAULT_CURATOR_USER_ID = 154493;       2    /** @var AddressBookBuilder $addressFactory */       protected $addressFactory;       .    /** @var UserRepository $userRepository */       protected $userRepository;       (    /** @var UserBuilder $userBuilder */       protected $userBuilder;       %    /** @var CoreArtworkRepository */   %    protected $coreArtworkRepository;       ;    /** @var LegacyAddressReducer  $legacyAddressReducer */   $    protected $legacyAddressReducer;       D    /** @var \Palette\Adapters\Repositories\Legacy\UserRepository */   $    protected $legacyUserRepository;       G    /** @var \Palette\Adapters\Repositories\Legacy\ArtworkRepository */   '    protected $legacyArtworkRepository;       F    /** @var LegacyCollectionRepository $legacyCollectionRepository */   *    protected $legacyCollectionRepository;       N    /** @var \Palette\SaatchiArt\Ports\VatValidatorInterface $vatValidator  */       private $vatValidator;       ,    /** @var ImageUploader $imageUploader */       private $imageUploader;       <    /** @var UserSessionRepository $userSessionRepository */   #    private $userSessionRepository;       '    /** @var PayoutProviderInterface */   '    private $hyperwalletPayoutProvider;       !    /** @var ValidationFactory */       private $validationFactory;           /** @var bool */   1    private $shouldGetArtworkDataFromCoreArtwork;            public function __construct(   '        UserRepository $userRepository,   !        UserBuilder $userBuilder,   +        AddressBookBuilder $addressFactory,   5        CoreArtworkRepository $coreArtworkRepository,   3        LegacyAddressReducer $legacyAddressReducer,   3        LegacyUserRepository $legacyUserRepository,   9        LegacyArtworkRepository $legacyArtworkRepository,   ?        LegacyCollectionRepository $legacyCollectionRepository,   ,        VatValidatorInterface $vatValidator,   %        ImageUploader $imageUploader,   5        UserSessionRepository $userSessionRepository,   ;        PayoutProviderInterface $hyperwalletPayoutProvider,   -        ValidationFactory $validationFactory,   1        bool $shouldGetArtworkDataFromCoreArtwork       ) {   0        $this->userRepository = $userRepository;   *        $this->userBuilder = $userBuilder;   0        $this->addressFactory = $addressFactory;   >        $this->coreArtworkRepository = $coreArtworkRepository;   <        $this->legacyAddressReducer = $legacyAddressReducer;   <        $this->legacyUserRepository = $legacyUserRepository;   B        $this->legacyArtworkRepository = $legacyArtworkRepository;   H        $this->legacyCollectionRepository = $legacyCollectionRepository;   ,        $this->vatValidator = $vatValidator;   .        $this->imageUploader = $imageUploader;   >        $this->userSessionRepository = $userSessionRepository;   F        $this->hyperwalletPayoutProvider = $hyperwalletPayoutProvider;   6        $this->validationFactory = $validationFactory;   Z        $this->shouldGetArtworkDataFromCoreArtwork = $shouldGetArtworkDataFromCoreArtwork;       }           /**        * Legacy Migration helper        *   I     * @return string address book item id that is used by product entity        */   \    public function migrateLegacyAddressOfUserId(string $userId, array $addressData): string       {   c        $userAddressItem = $this->addressFactory->buildLegacyAddressItemOfLegacyData($addressData);   <        $user = $this->userRepository->getUserById($userId);               if(!$user) {   A            $user = $this->userBuilder->buildSimpleUser($userId);   	        }       h        $existingAddressId = $this->legacyAddressReducer->findIfUserHasAddress($user, $userAddressItem);       !        if ($existingAddressId) {   &            return $existingAddressId;   	        }       ,        $user->addAddress($userAddressItem);   0        $this->userRepository->storeUser($user);       8        return $userAddressItem->getAddressBookItemId();       }       G    /** @throws \Palette\SaatchiArt\Exceptions\UserNotFoundException */   P    public function addAddressToUser(string $userId, array $addressData): string       {   Q        $userAddressItem = $this->addressFactory->buildAddressItem($addressData);       <        $user = $this->userRepository->getUserById($userId);               if( ! $user) {   R            throw new UserNotFoundException("User of id: $userId can't be found");   	        }       h        $existingAddressId = $this->legacyAddressReducer->findIfUserHasAddress($user, $userAddressItem);                if($existingAddressId) {   &            return $existingAddressId;   	        }       ,        $user->addAddress($userAddressItem);       0        $this->userRepository->storeUser($user);       8        return $userAddressItem->getAddressBookItemId();       }           /**        * @param string $userId   '     * @param string $addressBookItemId   *     * @param string $newAddressBookItemId        *        * @return void        *   $     * @throws UserNotFoundException        */   p    public function removeAddressOfUser(string $userId, string $addressBookItemId, string $newAddressBookItemId)       {   <        $user = $this->userRepository->getUserById($userId);           if ($user === null) {   R            throw new UserNotFoundException("User of id: $userId can't be found");   	        }       B        // validate that address with $newAddressBookItemId exists   =        $user->getAddressItemByItemId($newAddressBookItemId);   @        $user->removeAddressItemByAddressId($addressBookItemId);       X        $userArtworks = $this->coreArtworkRepository->getArtworksOfUserId((int)$userId);   -        foreach ($userArtworks as $artwork) {   E            $artwork->changeAddressBookItemId($newAddressBookItemId);   A            $this->coreArtworkRepository->storeArtwork($artwork);   	        }       0        $this->userRepository->storeUser($user);       }       G    /** @throws \Palette\SaatchiArt\Exceptions\UserNotFoundException */   l    public function changeAddressOfUser(string $userId, string $addressBookItemId, array $addressData): bool       {   <        $user = $this->userRepository->getUserById($userId);           if($user === null) {   R            throw new UserNotFoundException("User of id: $userId can't be found");   	        }       B        $addressData['address_book_item_id'] = $addressBookItemId;       Q        $userAddressItem = $this->addressFactory->buildAddressItem($addressData);       N        $user->changeAddressByAddressId($addressBookItemId, $userAddressItem);   0        $this->userRepository->storeUser($user);               return true;       }       G    /** @throws \Palette\SaatchiArt\Exceptions\UserNotFoundException */   u    public function healLegacyAddressOfUser(string $userId, string $oldAddressBookItemId, array $addressData): string       {   <        $user = $this->userRepository->getUserById($userId);           if($user === null) {   R            throw new UserNotFoundException("User of id: $userId can't be found");   	        }       Q        $userAddressItem = $this->addressFactory->buildAddressItem($addressData);       J        $user->healLegacyAddress($oldAddressBookItemId, $userAddressItem);   0        $this->userRepository->storeUser($user);       8        return $userAddressItem->getAddressBookItemId();       }       G    /** @throws \Palette\SaatchiArt\Exceptions\UserNotFoundException */   ]    public function getAddressOfUser(int $userId, string $addressBookItemId): AddressBookItem       {   D        $user = $this->userRepository->getUserById((string)$userId);               if($user === null) {   R            throw new UserNotFoundException("User of id: $userId can't be found");   	        }   9        return $user->getAddressById($addressBookItemId);       }       <    public function createUserOfUserId(string $userId): bool       {   =        $user = $this->userBuilder->buildSimpleUser($userId);   0        $this->userRepository->storeUser($user);           return true;       }           /**   C     * @throws \Palette\SaatchiArt\Exceptions\UserNotFoundException   )     * Reasons for UserNotFoundException:   ,     *  1) No Hyperwallet Credentials linked   h     *  2) No AddressBookItems, thus no AddressBook associated. Because no original artworks associated.        */   9    public function getUserOfUserId(string $userId): User       {   <        $user = $this->userRepository->getUserById($userId);               if( ! $user) {   R            throw new UserNotFoundException("User of id: $userId can't be found");   	        }           return $user;       }       !    /** @return \stdClass|null */   R    public function getUserDataOfEmailAndPassword(string $email, string $password)       {   1        $userData = $this->legacyUserRepository->   =            getUserDataOfEmailAndPassword($email, $password);           if (!$userData) {               return null;   	        }            $userId = $userData->id;   C        $userData->userFavorites = $this->legacyArtworkRepository->   :            getFavoriteArtworkIdUserArtsOfUserId($userId);       >        $lastCheckInDate = $this->getLastCheckInDate($userId);   @        $userData->artist_last_check_in_date = $lastCheckInDate;               return $userData;       }       ?    private function getOrCreateUserByUserId(int $userId): User       {   E        $user = $this->userRepository->getUserById((string) $userId);           if ($user === null) {   I            return $this->userBuilder->buildSimpleUser((string) $userId);   	        }               return $user;       }           /**        * @throws \DomainException        *        * @return array like this:   
     * ```        * [   4     *     'mysql' => [ (mysql user data here...) ],   <     *     'couchbase' => [ (couchbase user data here...) ],        *     'id' => {int},        * ]   
     * ```        */   <    public function createLegacyUser(array $userData): array       {   +        $this->validationFactory->validate(               $userData,   2            ['user_type_id' => 'required|integer']   
        );   B        return $this->legacyUserRepository->createUser($userData);       }       3    public function isArtist(int $userTypeId): bool       {   I        return $userTypeId === LegacyUserRepository::USER_TYPE_ID_ARTIST;       }       D    public function getUserTypeByUserTypeId(int $userTypeId): string       {   G        if (!isset(LegacyUserRepository::USER_TYPE_IDS[$userTypeId])) {   c            throw new \UnexpectedValueException("No user type found for user_type_id $userTypeId");   	        }       @        return LegacyUserRepository::USER_TYPE_IDS[$userTypeId];       }       A    public function getLegacyUserDataOfUserId(int $userId): array       {   W        $userData = $this->legacyUserRepository->getCouchbaseUserDataOfUserId($userId);   !        if ($userData === null) {               return [];   	        }       T        $mysqlData = $this->legacyUserRepository->getMysqlUserDataOfUserId($userId);   "        if ($mysqlData !== null) {   1            $userData['mysql_data'] = $mysqlData;   	        }               return $userData;       }           /**   0     * Get customer data from legacy MySQL by ID        *   8     * There are no Couchbase doc for guest customers so   4     * we can't use getLegacyUserDataOfUserId method        *        * @param int $customerId   #     * @return array<string, mixed>   $     * @throws UserNotFoundException        */   E    public function getLegacyCustomerDataById(int $customerId): array       {   [        $customerData = $this->legacyUserRepository->getMysqlUserDataOfUserId($customerId);       %        if ($customerData === null) {   V            throw new UserNotFoundException("Customer of ID {$customerId} not found");   	        }               return $customerData;       }       =    public function getLegacyUserByUsername(string $username)       {   N        $userData = $this->legacyUserRepository->getUserOfUsername($username);       !        if ($userData === null) {               return null;   	        }               return [   '            'user_id' => $userData->id,   /            'is_deleted' => $userData->deleted,   
        ];       }       ^    public function getLegacyUserCollectionsRecentlyTouched(int $collectionOwnerUserId): array       {   x        $collections = $this->legacyCollectionRepository->getRecentlyTouchedCollectionsByUserId($collectionOwnerUserId);           return $collections;       }       o    public function getLegacyUserCollectionsHavingArtwork(int $collectionOwnerUserId, string $artworkId): array       {   �        $collections = $this->legacyCollectionRepository->getRecentlyTouchedCollectionsByUserIdHavingArtwork($collectionOwnerUserId, $artworkId);           return $collections;       }           /** @return void */   D    public function updateLastLoginOfUserId(int $userId, string $ip)       {   K        $this->legacyUserRepository->updateLastLoginOfUserId($userId, $ip);       }           /**        * @return void        *   $     * @throws UserNotFoundException        */   2    public function logUserInByUserId(int $userId)       {   8        $user = $this->getOrCreateUserByUserId($userId);           $user->login();   0        $this->userRepository->storeUser($user);       }       G    public function registerUserByUserId(int $userId, string $userType)       {   8        $user = $this->getOrCreateUserByUserId($userId);   #        $user->register($userType);   0        $this->userRepository->storeUser($user);       }       @    public function getUserDataByAppleId(string $appleId): array       {   P        $userData = $this->legacyUserRepository->getUserDataByAppleId($appleId);   $        $userId   = $userData['id'];               // add favorites   w        $userData['favorites'] = $this->legacyArtworkRepository->getFavoriteNonDeletedArtworkIdsByUserId($userId, 500);               // add checkin date   T        $userData['artist_last_check_in_date'] = $this->getLastCheckInDate($userId);               return $userData;       }       u    public function registerUserByAppleId(string $appleId, string $email, string $firstName, string $lastName): array       {   +        // validate user email and apple id   /        if ($appleId === '' || $email === '') {   Z            throw new \InvalidArgumentException("User email and Apple ID can't be empty");   	        }       S        // check if user with given email already exists - then link it to apple id   2        $userId = $this->getUserIdOfEmail($email);           if ($userId !== null) {   P            $this->legacyUserRepository->linkUserIdToAppleId($userId, $appleId);   9            return $this->getUserDataByAppleId($appleId);   	        }       5        // no user with such email - let's create one   =        $userData = $this->legacyUserRepository->createUser([   #            'email'      => $email,   '            'first_name' => $firstName,   &            'last_name'  => $lastName,   %            'apple_id'   => $appleId,           ]);   G        $userData['is_new_user'] = true; // required by API transformer               return $userData;       }       ,    /** @return array<string, int|object> */   G    public function getUserDataOfFacebookUserId(string $facebookUserId)       {   J        // will throw \Palette\SaatchiArt\Exceptions\UserNotFoundException           // if not found   1        $userData = $this->legacyUserRepository->   9            getUserDataOfFacebookUserId($facebookUserId);       T        $this->validationFactory->validate($userData, ['id' => 'required|integer']);   "        $userId = $userData['id'];               // add favorites   E        $userData['userFavorites'] = $this->legacyArtworkRepository->   :            getFavoriteArtworkIdUserArtsOfUserId($userId);       T        $userData['artist_last_check_in_date'] = $this->getLastCheckInDate($userId);               return $userData;       }           /** @return string|null */   4    private function getLastCheckInDate(int $userId)       {           try {   D            $user = $this->userRepository->getUserByUserId($userId);   4        } catch (UserNotFoundException $exception) {               return null;   	        }   7        $lastCheckInDate = $user->getLastCheckinDate();   (        if ($lastCheckInDate === null) {               return null;   	        }       ;        return $lastCheckInDate->format('Y-m-d\TH:i:s.vO');       }           /** @return int|null */   3    public function getUserIdOfEmail(string $email)       {   ,        return $this->legacyUserRepository->   %            getUserIdOfEmail($email);       }           /** @return void */   S    public function linkUserIdToFacebookUserId(int $userId, string $facebookUserId)       {   %        $this->legacyUserRepository->   A            linkUserIdToFacebookUserId($userId, $facebookUserId);       }           /**        * @return void        *        * @throws \DomainException        */   \    public function updatePreferredUnitOfMeasurement(int $userId, string $unitOfMeasurement)       {   B        if (!$unitOfMeasurement || !in_array($unitOfMeasurement, [   :            LegacyUserRepository::INCH_MEASUREMENT_SYSTEM,   ?            LegacyUserRepository::CENTIMETER_MEASUREMENT_SYSTEM           ])) {   X            throw new \DomainException("Unexpected value string: '{$unitOfMeasurement}'"   W                . " for preferred measurement system provided for user id: {$userId}");   	        }       D        $legacyUserData = $this->getLegacyUserDataOfUserId($userId);   C        $legacyUserData['measurement_system'] = $unitOfMeasurement;   X        $this->legacyUserRepository->storeLegacyUser($legacyUserData, (string) $userId);       }           /**        * @return void        *   (     * @throws \UnexpectedValueException         * @throws \RuntimeException        */   g    public function updatePreferredUnitOfMeasurementInUsersSession(int $userId, string $userSessionKey)       {   ]        $legacyUserData = $this->legacyUserRepository->getCouchbaseUserDataOfUserId($userId);       C        $unitOfMeasurement = $legacyUserData['measurement_system'];   "        if (!$unitOfMeasurement) {   j            throw new \UnexpectedValueException('User unexpectedly has no preferred unit of measurement');   	        }       L        $session = $this->userSessionRepository->findByKey($userSessionKey);           if (!$session) {   j            throw new \UnexpectedValueException('Failed to update user session data. No session exists.');   	        }       X        if ($unitOfMeasurement === ($session['Saatchi']['measurementSystem'] ?? null)) {   -            return; // No need to do anything   	        }   F        $session['Saatchi']['measurementSystem'] = $unitOfMeasurement;       T        if (!$this->userSessionRepository->updateByKey($userSessionKey, $session)) {   N            throw new \RuntimeException('Failed to update user session data');   	        }       }       ;    public function sendUserOfUserIdToVacation(int $userId)       {   D        $legacyUserData = $this->getLegacyUserDataOfUserId($userId);   B        $legacyUserData['other_attributes']['on_vacation'] = true;   X        $this->legacyUserRepository->storeLegacyUser($legacyUserData, (string) $userId);       }       >    public function bringUserOfUserIdFromVacation(int $userId)       {   D        $legacyUserData = $this->getLegacyUserDataOfUserId($userId);   C        $legacyUserData['other_attributes']['on_vacation'] = false;   W        $this->legacyUserRepository->storeLegacyUser($legacyUserData, (string)$userId);       }           /**   #     * @return array<string, mixed>        *   $     * @throws UserNotFoundException        */   B    public function getUserProfileDataOfUserId(int $userId): array       {   %        // todo: refactor all of this   ]        $legacyUserData = $this->legacyUserRepository->getCouchbaseUserDataOfUserId($userId);   '        if (null === $legacyUserData) {   Y            throw new UserNotFoundException("Legacy User with id: {$userId} not found.");   	        }       B        $userType = (int) $legacyUserData['user_type_id'] ?? null;   ,        if ($userType === UserType::GUEST) {   G            throw new UserNotFoundException("User $userId not found.");   	        }       �        $maximumIdsToPull = 25; // We pull more than the 9 needed, because we cannot trust the DB if the given artwork is deleted or not               $userProfileData = [   !            'user_id' => $userId,   $            'userType' => $userType,   2            'legacy_user_data' => $legacyUserData,   h            'favorites_total' => $this->legacyArtworkRepository->countFavoriteArtworksByUserId($userId),   h            'collections_total' => $this->legacyCollectionRepository->countCollectionsByUserId($userId),       D            'favorite_artwork_ids' => $this->legacyArtworkRepository   V                ->getFavoriteNonDeletedArtworkIdsByUserId($userId, $maximumIdsToPull),       J            'collections_artwork_ids' => $this->legacyCollectionRepository   O                ->getIdUserArtIdsInUsersCollections($userId, $maximumIdsToPull)   "                ->toArray() ?: [],   
        ];       -        if ($userType === UserType::ARTIST) {   p            $userProfileData['artworks_count'] = $this->legacyArtworkRepository->countArtworksByUserId($userId);   	        }                return $userProfileData;       }           /**   3     * Will validate and then update user's vat id.        *   G     * @throws ValidationException - Invalid Value Added Tax Identifier   9     * @throws \DomainException - Service was unavailable   $     * @throws UserNotFoundException        *        * @return void        */   2    public function updateValueAddedTaxIdentifier(           int $userId,           string $vatId,   8        bool $skipUnreliableThirdPartyValidation = false       ) {   ]        $legacyUserData = $this->legacyUserRepository->getCouchbaseUserDataOfUserId($userId);   '        if (null === $legacyUserData) {   R            throw new UserNotFoundException("User with id: {$userId} not found.");   	        }       3        if (!$skipUnreliableThirdPartyValidation) {   2            $this->vatValidator->validate($vatId);   	        }       .        $legacyUserData['vat']['id'] = $vatId;   <        $legacyUserData['vat']['modified_at'] = gmdate('c');   3        unset($legacyUserData['vat']['is_exempt']);       W        $this->legacyUserRepository->storeLegacyUser($legacyUserData, (string)$userId);       }       :    public function markAsValueAddedTaxExempt(int $userId)       {   ]        $legacyUserData = $this->legacyUserRepository->getCouchbaseUserDataOfUserId($userId);   '        if (null === $legacyUserData) {   R            throw new UserNotFoundException("User with id: {$userId} not found.");   	        }       ,        $legacyUserData['vat']['id'] = null;   <        $legacyUserData['vat']['modified_at'] = gmdate('c');   3        $legacyUserData['vat']['is_exempt'] = true;       W        $this->legacyUserRepository->storeLegacyUser($legacyUserData, (string)$userId);       }           /** @return void */   J    public function chooseArtworkForHeroImage(int $userId, int $artworkId)       {   ]        $artworkData = $this->legacyArtworkRepository->getArtworkDataOfIdUserArt($artworkId);       w        $uploadedImage = $this->imageUploader->uploadArtworkHeroImage($userId, $artworkId, $artworkData['main_image']);       v        $this->legacyUserRepository->updateHeroImage($userId, $uploadedImage->getBucket(), $uploadedImage->getPath());       }           /** @return void */   X    public function submitCuratorsNotesAnswersToUser(string $userId, array $answersData)       {   <        $user = $this->userRepository->getUserById($userId);               if($user === null) {   A            $user = $this->userBuilder->buildSimpleUser($userId);   	        }       8        $user->submitCuratorsNotesAnswers($answersData);       0        $this->userRepository->storeUser($user);       }       -    public function updateEmailInHyperwallet(   K        HyperwalletPayoutUserCredentials $hyperwalletPayoutUserCredentials,           string $newEmail       ) {   (        $this->hyperwalletPayoutProvider   L            ->updateUserEmail($hyperwalletPayoutUserCredentials, $newEmail);       }       ,    /** @return (object<string, mixed>)[] */   0    public function getCuratorsUserData(): array       {   O        $allCurators = $this->legacyUserRepository->getCuratorsMysqlUserData();       7        return \array_map(static function ($userData) {   T            $userData->is_default = $userData->id === self::DEFAULT_CURATOR_USER_ID;               return $userData;           }, $allCurators);       }           /**   (     * Creates the Holy Trinity of User:        *  - MySQL record        *  - Legacy User doc        *  - Core User doc        *   ,     * @param array<string, mixed> $userData        * @return int   "     * @throws CreateUserException        */   =    public function registerRegularUser(array $userData): int       {           try {   8            // create MySQL & legacy Couchbase User docs   K            $userData = $this->legacyUserRepository->createUser($userData);   .            $userId   = (int) $userData['id'];       #            // create core User doc   J            $user = $this->userBuilder->buildSimpleUser((string) $userId);   4            $this->userRepository->storeUser($user);                   return $userId;   2        } catch (\CouchbaseException $exception) {   d            $message = "Failed to create user for {$userData['email']}: {$exception->getMessage()}";   @            throw new CreateUserException($message, $exception);   	        }       }       A    public function registerPreApprovedUser(array $userData): int       {   <        // create MySQL, legacy and Core Couchbase User docs   8        $userId = $this->registerRegularUser($userData);       C        // to make user "verified_to_sell", we need to update MySQL   )        // and legacy Couchbase User doc:   ?        $this->legacyUserRepository->verifyUserToSell($userId);       I        // no need to update Core User doc - it doesn't store information   ;        // about account verification/identity confirmation               return $userId;       }           /**        * @return void        *   -     * @throws UserNotVerifiedToSellException   $     * @throws UserNotFoundException        */   ;    public function ensureUserIsVerifiedToSell(int $userId)       {           $userData = $this   "            ->legacyUserRepository   4            ->getCouchbaseUserDataOfUserId($userId);       !        if ($userData === null) {   I            throw new UserNotFoundException("User {$userId} not found.");   	        }       C        $isVerifiedToSell = $userData['verified_to_sell'] ?? false;       *        if ($isVerifiedToSell === false) {   `            throw new UserNotVerifiedToSellException("User {$userId} is not verified to sell.");   	        }       }   }5��