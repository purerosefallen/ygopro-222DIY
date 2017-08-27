--★お姫様聖女 桜
function c114005000.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c114005000.target)
	e1:SetOperation(c114005000.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,114005000)
	e2:SetCondition(c114005000.spcon)
	e2:SetCost(c114005000.spcost)
	e2:SetTarget(c114005000.sptg)
	e2:SetOperation(c114005000.spop)
	c:RegisterEffect(e2)
	if not c114005000.global_check then
		c114005000.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114005000.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
--search
function c114005000.otofilter(c)
	return c:IsSetCard(0xab0) or c:IsCode(21175632) or c:IsCode(68018709)
end
function c114005000.filter(c)
	return ( ( c:IsSetCard(0x221) and c:IsLevelBelow(4) ) or c:IsCode(114000821) ) and c:IsAbleToHand()
end
function c114005000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114005000.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114005000.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114005000.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--spsummon
--2nd effect limit check (half)
function c114005000.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p1=nil
	local p2=nil
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetPosition(),0x5)~=0 then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114005000,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114005000,RESET_PHASE+PHASE_END,0,1) end
end
--end of half limt
function c114005000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil
end
function c114005000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.GetFlagEffect(tp,114005000)==0 end -- and not Duel.CheckSummonActivity(tp) 
	--summon limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	--spsummon limit
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c114005000.splimit)
	Duel.RegisterEffect(e2,tp)
	--remove as cost
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c114005000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumpos,0x5)~=0
	--POS_FACEUP_ATTACK	= 0x1 + POS_FACEUP_DEFENSE = 0x4
end
function c114005000.spfilter(c,e,tp)
	return c114005000.otofilter(c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) --not 0x199
end
function c114005000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114005000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114005000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114005000.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,g) --confirm cards
	end
end