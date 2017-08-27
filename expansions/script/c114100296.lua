--Catch Your Dreams!!
function c114100296.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c114100296.condition)
	e1:SetOperation(c114100296.activate)
	c:RegisterEffect(e1)
	if c114100296.global_effect==nil then
		c114100296.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c114100296.addcount)
		Duel.RegisterEffect(ge1,0)
	end
	--Duel.AddCustomActivityCounter(114100296,ACTIVITY_CHAIN,c114100296.chainfilter)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c114100296.scon)
	e2:SetCost(c114100296.scost)
	e2:SetTarget(c114100296.stg)
	e2:SetOperation(c114100296.sop)
	c:RegisterEffect(e2)
end
function c114100296.addcount(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsRace(RACE_SPELLCASTER) and rc:IsSetCard(0x221)
		and not rc:IsStatus(STATUS_BATTLE_DESTROYED) then
		local p=re:GetOwnerPlayer()
		Duel.RegisterFlagEffect(p,114100296,RESET_PHASE+PHASE_END,0,1)
	end
end
--function c114100296.chainfilter(re,tp,cid)
--	local rc=re:GetHandler()
--	return re:IsActiveType(TYPE_MONSTER) and rc:IsRace(RACE_SPELLCASTER) and rc:IsSetCard(0x221) and re:GetActivateLocation(LOCATION_MZONE) and re:GetOwnerPlayer()==tp
--end

function c114100296.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,114100296)>0
end
function c114100296.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1)
	e1:SetOperation(c114100296.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c114100296.dfilter(c)
	return c:IsSetCard(0x221) and c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() 
end
function c114100296.failfilter(c)
	return c:IsSetCard(0x221) and c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER)
end
function c114100296.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114100296.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.GetMatchingGroupCount(c114100296.failfilter,tp,LOCATION_DECK,0,1,nil)==0 then
			local chg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
			Duel.ConfirmCards(tp,chg)
			Duel.ConfirmCards(1-tp,chg)
			Duel.ShuffleDeck(tp)
		end
	end
end
--summon
function c114100296.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x221) and c:IsRace(RACE_SPELLCASTER)
end
function c114100296.confilter2(c)
	return not c114100296.confilter(c)
end
function c114100296.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c114100296.confilter,tp,LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(c114100296.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c114100296.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c114100296.filter(c)
	return c:IsSetCard(0x221) and c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER) and c:IsSummonable(true,nil)
end
function c114100296.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114100296.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c114100296.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c114100296.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
