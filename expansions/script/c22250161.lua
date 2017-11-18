--利维艾拉 乌尔斯拉
function c22250161.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22250161,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22250161.stg)
	e1:SetOperation(c22250161.sop)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetOperation(c22250161.tgop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22250161,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(c22250161.spcon)
	e5:SetTarget(c22250161.sptg)
	e5:SetOperation(c22250161.spop)
	c:RegisterEffect(e5)
end
c22250161.named_with_Riviera=1
function c22250161.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22250161.filter(c,e,zone)
	return c22250161.IsRiviera(c) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,e,0,zone)
end
function c22250161.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and zone~=0 and Duel.IsExistingMatchingCard(c22250161.filter,tp,LOCATION_HAND,0,1,nil,e,0,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22250161.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c22250161.filter,tp,LOCATION_HAND,0,1,1,nil,e,0,zone)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,0,zone)
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetValue(tc:GetAttack())
			c:RegisterEffect(e1)
		end
	end
end
function c22250161.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION) then return end
	if Duel.GetCurrentPhase()<=PHASE_END then
		c:RegisterFlagEffect(22250161,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,2)
	else
		c:RegisterFlagEffect(22250161,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c22250161.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(22250161)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22250161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22250161.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end