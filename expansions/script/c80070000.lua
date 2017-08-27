--魂缚门
function c80070000.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,80070000+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e0) 
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c80070000.target)
	e1:SetOperation(c80070000.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c80070000.target)
	e2:SetOperation(c80070000.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c80070000.target2)
	e3:SetOperation(c80070000.activate2)
	c:RegisterEffect(e3)   
end
function c80070000.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()<Duel.GetLP(tp)
end
function c80070000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c80070000.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c80070000.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()<Duel.GetLP(tp) then
		if Duel.GetLP(tp)>4000 then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_DECKSHF)
		Duel.Damage(tp,1600,REASON_EFFECT)
		Duel.Damage(1-tp,1600,REASON_EFFECT)
		elseif Duel.GetLP(tp)<4000 then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Damage(tp,800,REASON_EFFECT)
		Duel.Damage(1-tp,800,REASON_EFFECT)
		elseif Duel.GetLP(tp)==4000 then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		Duel.Damage(tp,1000,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c80070000.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()<Duel.GetLP(tp)
end
function c80070000.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80070000.filter2,1,nil,tp) end
	local g=eg:Filter(c80070000.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80070000.filter3(c,e,tp)
	return c:IsFaceup() and c:GetAttack()<Duel.GetLP(tp) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c80070000.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c80070000.filter3,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.GetLP(tp)>4000 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_DECKSHF)
		Duel.Damage(tp,1600,REASON_EFFECT)
		Duel.Damage(1-tp,1600,REASON_EFFECT)
		elseif Duel.GetLP(tp)<4000 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(tp,800,REASON_EFFECT)
		Duel.Damage(1-tp,800,REASON_EFFECT)
		elseif Duel.GetLP(tp)==4000 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
		Duel.Damage(tp,1000,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end