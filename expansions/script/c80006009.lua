--1998 十六夜木头
function c80006009.initial_effect(c) 
	c:EnableReviveLimit()
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80006009,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,80006009)
	e2:SetTarget(c80006009.damtg)
	e2:SetOperation(c80006009.damop)
	c:RegisterEffect(e2) 
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c80006009.rlevel)
	c:RegisterEffect(e3) 
	--ritual material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	c:RegisterEffect(e4)
end
function c80006009.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL 
end
function c80006009.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2de) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c80006009.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c80006009.thfilter1(c)
	return c:IsSetCard(0x2de) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c80006009.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006009.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c80006009.chainlm)
end
function c80006009.chainlm(e,rp,tp)
	return tp==rp
end
function c80006009.tgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80006009.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80006009.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2de)
end
function c80006009.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006009.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local dam=Duel.GetMatchingGroupCount(c80006009.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*400
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetChainLimit(c80006009.chainlm)
end
function c80006009.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c80006009.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*400
	Duel.Damage(p,d,REASON_EFFECT)
end