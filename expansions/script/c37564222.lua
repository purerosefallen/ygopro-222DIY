--Sawawa-Cirno Break
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564222
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
Senya.SawawaCommonEffect(c,1,true,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564222,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,37564222)
	e1:SetCondition(Senya.CheckNoExtra)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and (not c:IsType(TYPE_PENDULUM)) and c:IsControlerCanBeChanged() and c:GetSummonPlayer()==1-tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,e:GetHandler(),tp) end
	local g=eg:Filter(cm.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function cm.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsPreviousLocation(LOCATION_EXTRA) and (not c:IsType(TYPE_PENDULUM)) and c:IsControlerCanBeChanged() and c:GetSummonPlayer()==1-tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		if Duel.GetControl(tc,tp) then
		elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end