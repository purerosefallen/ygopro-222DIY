--自由的引领者·跃动的拉兹
function c10131007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--xyz
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(10131007,0))
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10131007.discon)
	e1:SetTarget(c10131007.distg)
	e1:SetOperation(c10131007.disop)
	c:RegisterEffect(e1)  
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(10131007,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10131007)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10131007.destg)
	e2:SetOperation(c10131007.desop)
	c:RegisterEffect(e2)  
end
c10131007.pendulum_level=4
function c10131007.tdfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5338) and c:IsAbleToExtra()
end
function c10131007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10131007.tdfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c10131007.mtfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c10131007.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c10131007.tdfilter,tp,LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=ng:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 and g:GetCount()>0 and c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(10131007,2)) then
	Duel.BreakEffect()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local dg=g:Select(tp,1,1,nil)
		  Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c10131007.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10131007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		local g=Group.FromCards(re:GetHandler(),c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	end
end
function c10131007.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
	   local g=Group.FromCards(re:GetHandler(),c)
	   Duel.Destroy(g,REASON_EFFECT)
	end
end

