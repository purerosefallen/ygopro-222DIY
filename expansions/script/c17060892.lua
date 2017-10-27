--ダ·ヴィンチ
function c17060892.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060892,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060892.spcon)
	e1:SetTarget(c17060892.sptg)
	e1:SetOperation(c17060892.spop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060892,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c17060892.penon)
	e2:SetTarget(c17060892.pentg)
	e2:SetOperation(c17060892.penop)
	c:RegisterEffect(e2)
end
c17060892.is_named_with_Dark_Degenerate=1
function c17060892.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060892.cfilter(c)
	return c17060892.IsDark_Degenerate(c) and not c:IsCode(17060892)
end
function c17060892.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17060892.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060892.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
	end
end
function c17060892.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c17060892.penon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) and not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060892.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17060892.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end