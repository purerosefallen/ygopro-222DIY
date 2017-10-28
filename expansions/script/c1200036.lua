--靜儀式 鏡天城 
function c1200036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200036,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,1200036)
	e4:SetCondition(c1200036.thcon)
	e4:SetTarget(c1200036.thtg)
	e4:SetOperation(c1200036.thop)
	c:RegisterEffect(e4)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200036,1))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,1200036)
	e4:SetCondition(c1200036.recon)
	e4:SetTarget(c1200036.retg)
	e4:SetOperation(c1200036.reop)
	c:RegisterEffect(e4)
end
function c1200036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c1200036.thfilter(c,lp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba) and c:IsAbleToHand() and c:GetDefense()<lp
end
function c1200036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local lp=math.abs(lp1-lp2)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200036.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1200036.thop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local lp=math.abs(lp1-lp2)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not Duel.IsExistingMatchingCard(c1200036.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lp) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200036.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lp)
	local tc=g:GetFirst()
	if tc then 
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,tc)
			Duel.Damage(tp,tc:GetDefense(),REASON_EFFECT)
		end
	end
end
function c1200036.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c1200036.refilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba) and c:IsReleasable()
end
function c1200036.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200036.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,0,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c1200036.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not Duel.IsExistingMatchingCard(c1200036.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200036.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then 
		if Duel.Release(tc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,tc:GetBaseAttack()*2,REASON_EFFECT)
		end
	end
end