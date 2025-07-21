-- CreateTable
CREATE TABLE "User" (
    "user_id" BIGSERIAL NOT NULL,
    "wallet_address" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "profile_pic" TEXT,
    "subscription_status" BOOLEAN NOT NULL DEFAULT false,
    "total_points" BIGINT NOT NULL DEFAULT 0,
    "total_steps" BIGINT NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "Quest" (
    "quest_id" BIGSERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "target_steps" BIGINT NOT NULL,
    "reward_type" TEXT NOT NULL,
    "points" BIGINT NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "claimed" TIMESTAMP(3),
    "difficulty" TEXT NOT NULL,

    CONSTRAINT "Quest_pkey" PRIMARY KEY ("quest_id")
);

-- CreateTable
CREATE TABLE "UserQuestProfile" (
    "uqg_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "quest_id" BIGINT NOT NULL,
    "progress" BIGINT NOT NULL,
    "status" TEXT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserQuestProfile_pkey" PRIMARY KEY ("uqg_id")
);

-- CreateTable
CREATE TABLE "TrackSession" (
    "session_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "quest_id" BIGINT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "ended_at" TIMESTAMP(3),
    "gpx_data" JSONB NOT NULL,
    "notes" TEXT,
    "created_by" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TrackSession_pkey" PRIMARY KEY ("session_id")
);

-- CreateTable
CREATE TABLE "MapTrack" (
    "track_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "quest_id" BIGINT NOT NULL,
    "session_id" BIGINT NOT NULL,
    "latitude" DECIMAL(9,6) NOT NULL,
    "longitude" DECIMAL(9,6) NOT NULL,
    "fieldTimestamp" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MapTrack_pkey" PRIMARY KEY ("track_id")
);

-- CreateTable
CREATE TABLE "StepRecord" (
    "record_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "steps" BIGINT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "location_data" TEXT,
    "valid" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "StepRecord_pkey" PRIMARY KEY ("record_id")
);

-- CreateTable
CREATE TABLE "SocialShare" (
    "share_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "share_type" TEXT NOT NULL,
    "content_link" TEXT NOT NULL,
    "shared_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SocialShare_pkey" PRIMARY KEY ("share_id")
);

-- CreateTable
CREATE TABLE "RewardClaim" (
    "claim_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "quest_id" BIGINT NOT NULL,
    "tx_hash" TEXT NOT NULL,
    "points_rewarded" BIGINT NOT NULL,
    "reward_type" TEXT NOT NULL,
    "claim_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RewardClaim_pkey" PRIMARY KEY ("claim_id")
);

-- CreateTable
CREATE TABLE "NFT" (
    "nft_id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "type" TEXT NOT NULL,
    "image_url" TEXT NOT NULL,
    "metadata" JSONB NOT NULL,
    "minted_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NFT_pkey" PRIMARY KEY ("nft_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_wallet_address_key" ON "User"("wallet_address");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "UserQuestProfile" ADD CONSTRAINT "UserQuestProfile_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserQuestProfile" ADD CONSTRAINT "UserQuestProfile_quest_id_fkey" FOREIGN KEY ("quest_id") REFERENCES "Quest"("quest_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrackSession" ADD CONSTRAINT "TrackSession_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrackSession" ADD CONSTRAINT "TrackSession_quest_id_fkey" FOREIGN KEY ("quest_id") REFERENCES "Quest"("quest_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MapTrack" ADD CONSTRAINT "MapTrack_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MapTrack" ADD CONSTRAINT "MapTrack_quest_id_fkey" FOREIGN KEY ("quest_id") REFERENCES "Quest"("quest_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MapTrack" ADD CONSTRAINT "MapTrack_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "TrackSession"("session_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StepRecord" ADD CONSTRAINT "StepRecord_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SocialShare" ADD CONSTRAINT "SocialShare_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RewardClaim" ADD CONSTRAINT "RewardClaim_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RewardClaim" ADD CONSTRAINT "RewardClaim_quest_id_fkey" FOREIGN KEY ("quest_id") REFERENCES "Quest"("quest_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NFT" ADD CONSTRAINT "NFT_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;
