--★豊穣を齎す伏兵
function c114100284.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,114100284)
	e1:SetCondition(c114100284.spcon)
	e1:SetOperation(c114100284.spop)
	c:RegisterEffect(e1)
end
function c114100284.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c114100284.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	--e2:SetCode(EVENT_PHASE+PHASE_END) -- for puzzle testing only
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c114100284.tgcon)
	e2:SetTarget(c114100284.tgtg)
	e2:SetOperation(c114100284.tgop)
	e2:SetReset(RESET_EVENT+0xee0000)
	c:RegisterEffect(e2)
end
function c114100284.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
	--return Duel.GetTurnPlayer()~=tp -- for puzzle testing only
end
function c114100284.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c114100284.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,c)
	if mg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(114100284,0)) then
		local tg=mg:Select(1-tp,1,1,nil)
		Duel.HintSelection(tg)
		if Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
		end
	end
end
