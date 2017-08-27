--★憎しみの魔王オディオ
function c114100001.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c114100001.spcon0)
	e2:SetOperation(c114100001.spop0)
	c:RegisterEffect(e2)	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c114100001.spcost)
	e3:SetTarget(c114100001.sptg)
	e3:SetOperation(c114100001.spop)
	c:RegisterEffect(e3)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c114100001.atkcon)
	e1:SetTarget(c114100001.atktg)
	e1:SetOperation(c114100001.atkop)
	c:RegisterEffect(e1)
end
function c114100001.spfilter(c)
	return c:IsSetCard(0x221) and c:IsAbleToRemoveAsCost()
end
function c114100001.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingMatchingCard(c114100001.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114100001.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100001.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end


function c114100001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c114100001.spfilter2(c,e,tp)
	return c:IsSetCard(0x221) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114100001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c114100001.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c114100001.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c114100001.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c114100001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(2500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		c:RegisterFlagEffect(114100001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end


function c114100001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(114100001)==0 then return false end
	return (Duel.GetAttacker():IsControler(tp) and not Duel.GetAttacker():IsCode(114100001))
		or (Duel.GetAttackTarget() and Duel.GetAttackTarget():IsControler(tp) and not Duel.GetAttackTarget():IsCode(114100001))
end
function c114100001.filter(c)
	return c:IsAbleToRemove()
end
function c114100001.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():GetFlagEffect(114100002)==0 end
	local g=Duel.GetMatchingGroup(c114100001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(114100002,RESET_PHASE+RESET_DAMAGE_CAL,0,1)
end
function c114100001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c114100001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end