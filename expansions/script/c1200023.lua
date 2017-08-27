--LA SY 友引的夕碧姬
function c1200023.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c1200023.efilter)
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(1200023,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1200023)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1200023.ttarget)
	e1:SetOperation(c1200023.toperation)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(1200023,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1200023)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c1200023.sptg)
	e1:SetOperation(c1200023.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c1200023.sdcon)
	c:RegisterEffect(e1)
	--toPZone
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200023,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c1200023.tpcost)
	e3:SetTarget(c1200023.tptar)
	e3:SetOperation(c1200023.tpop)
	c:RegisterEffect(e3)
end
function c1200023.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c1200023.sdcon(e)
	local c=e:GetHandler()
	return c:GetRightScale()<1 or c:GetRightScale()>12 or c:GetLeftScale()<1 or c:GetLeftScale()>12
end
function c1200023.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba) and not c:IsType(TYPE_TUNER)
end
function c1200023.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1200023.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200023.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1200023.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_MZONE)
end
function c1200023.toperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
			local j=tc:GetRank()
			local k=tc:GetLevel()
		local m=j+k
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(m)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			c:RegisterEffect(e2)
		end
	end
end
function c1200023.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xfba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1200023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1200023.spfilter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function c1200023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstMatchingCard(c1200023.spfilter,tp,LOCATION_PZONE,0,e:GetHandler(),e,tp)
	if tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.BreakEffect()
			local j=tc:GetRank()
			local k=tc:GetLevel()
			local m=j+k
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(-m)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			c:RegisterEffect(e2)
		end
	end
end
function c1200023.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1200023.tptar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200023.tpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c1200023.tpfilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c1200023.tpop(e,tp,eg,ep,ev,re,r,rp)
	if  not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return false end
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.IsExistingMatchingCard(c1200023.tpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c1200023.tpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,e:GetHandler())
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP, true)
	end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(c1200023.tpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c1200023.tpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,e:GetHandler())
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP, true)
	end
end




