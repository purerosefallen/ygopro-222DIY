--白泽球键盘手
function c22220007.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,22220007)
	e1:SetCost(c22220007.spcost)
	e1:SetCondition(c22220007.spcon)
	e1:SetTarget(c22220007.sptg)
	e1:SetOperation(c22220007.spop)
	c:RegisterEffect(e1)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220007,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c22220007.condition)
	e1:SetTarget(c22220007.target)
	e1:SetOperation(c22220007.operation)
	c:RegisterEffect(e1)
	--yeha
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(22220007,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22220007.rmtg)
	e2:SetOperation(c22220007.rmop)
	c:RegisterEffect(e2)
end
c22220007.named_with_Shirasawa_Tama=1
function c22220007.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220007.cfilter(c,tp)
	return c:GetControler()==tp and c22220007.IsShirasawaTama(c)
end
function c22220007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22220007.cfilter,1,nil,tp)
end
function c22220007.costfilter(c)
	return c22220007.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c22220007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220007.costfilter,tp,LOCATION_DECK,0,1,nil) end
	local cg=Duel.SelectMatchingCard(tp,c22220007.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
end
function c22220007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22220007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22220007.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c22220007.filter(c)
	return (c:IsLevelBelow(2) or c:IsRankBelow(2)) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c22220007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220007.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c22220007.filter,tp,LOCATION_GRAVE,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c22220007.remfilter(c,atk)
	return c:IsAbleToRemove() and c:GetBaseAttack()<=atk and c:IsFaceup()
end
function c22220007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22220007.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		local atk=ct*300
		local ssg=Duel.GetMatchingGroup(c22220007.remfilter,tp,0,LOCATION_MZONE,nil,atk)
		Duel.Remove(ssg,POS_FACEUP,REASON_EFFECT)
	end
end
function c22220007.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c22220007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(22220007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c22220007.retcon)
		e1:SetOperation(c22220007.retop)
		Duel.RegisterEffect(e1,tp)
	end
	if (tc:IsLevelAbove(3) or tc:IsRankAbove(3)) and Duel.IsExistingMatchingCard(c22220007.thfilter,tp,LOCATION_DECK,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,c22220007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22220007.thfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand() and c22220007.IsShirasawaTama(c)
end
function c22220007.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(22220007)~=0
end
function c22220007.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end




