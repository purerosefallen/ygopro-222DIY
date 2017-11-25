--女仆装的小妖梦
function c1156001.initial_effect(c)
--
	c:EnableReviveLimit()
--
	aux.AddLinkProcedure(c,c1156001.matfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c1156001.tg1)
	e1:SetOperation(c1156001.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c1156001.tg2)
	c:RegisterEffect(e2)
--
end
--
function c1156001.matfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
--
function c1156001.tfilter1_1(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TOKEN) and c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function c1156001.tfilter1_2(c)
	return c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER) and c:GetLevel()<4 and c:IsAbleToGrave()
end
function c1156001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.IsExistingMatchingCard(c1156001.tfilter1_2,tp,LOCATION_DECK,0,1,nil) and zone~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1156002,0,0x4011,0,800,1,RACE_ZOMBIE,ATTRIBUTE_WIND) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not Duel.IsExistingMatchingCard(c1156001.tfilter1_1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end 
--
function c1156001.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(1156001,0)) then
		Duel.Hint(HINT_CARD,0,1156001)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c1156001.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				local zone=e:GetHandler():GetLinkedZone()
				local token=Duel.CreateToken(tp,1156002)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1_1:SetValue(1)
				e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e:GetHandler():RegisterEffect(e1_1,true)
			end
		end
	end
end
--
function c1156001.tg2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2_1:SetCategory(CATEGORY_TOHAND)
	e2_1:SetCode(EVENT_PHASE+PHASE_END)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCountLimit(1)
	e2_1:SetProperty(EFFECT_FLAG_REPEAT)
	e2_1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e2_1:SetCondition(c1156001.con2_1)
	e2_1:SetTarget(c1156001.tg2_1)
	e2_1:SetOperation(c1156001.op2_1)
	c:RegisterEffect(e2_1,true)
end
function c1156001.con2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c1156001.tg2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c1156001.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			Duel.Recover(tp,1200,REASON_EFFECT)
		end
	end
end
--

