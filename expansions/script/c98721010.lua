--抽卡蜥蜴+帽子戏法师
function c98721010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98721010)
	e1:SetTarget(c98721010.destg)
	e1:SetOperation(c98721010.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,98721110)
	e2:SetCondition(c98721010.spcon)
	c:RegisterEffect(e2)
end
function c98721010.desfilter(c)
	return c:IsSetCard(0xf1) and not c:IsCode(98721010)
end
function c98721010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c98721010.desfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c98721010.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c98721010.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and c:GetCode()~=98721010
end
function c98721010.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and
		Duel.IsExistingMatchingCard(c98721010.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
