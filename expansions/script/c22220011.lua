--小小的甜蜜白泽球
function c22220011.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,22220011)
	e1:SetCondition(c22220011.spcon)
	e1:SetCost(c22220011.spcost)
	e1:SetTarget(c22220011.sptg)
	e1:SetOperation(c22220011.spop)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c22220011.damcon)
	e2:SetTarget(c22220011.damtg)
	e2:SetOperation(c22220011.damop)
	c:RegisterEffect(e2)
	--Remove
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220011,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c22220011.thtg)
	e2:SetOperation(c22220011.thop)
	c:RegisterEffect(e2)
end
c22220011.named_with_Shirasawa_Tama=1
function c22220011.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22220011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,ev) end
	Duel.PayLPCost(tp,ev)
end
function c22220011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22220011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22220011.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsType(TYPE_MONSTER) and c22220011.IsShirasawaTama(tc)
end
function c22220011.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22220011.damop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c22220011.damcon1)
	e2:SetOperation(c22220011.damop1)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end
function c22220011.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22220011.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22220011.cfilter,1,nil,1-tp)
end
function c22220011.damop1(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c22220011.cfilter,nil,1-tp)*200
	Duel.Damage(1-tp,d1,REASON_EFFECT)
end
function c22220011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c22220011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_ONFIELD)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetOperation(c22220011.desop)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e4)
	end
end
function c22220011.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end




