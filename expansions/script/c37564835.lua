--3L·春色小径
local m=37564835
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCountLimit(1,m)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(Senya.delay)
	e2:SetCost(cm.DiscardHandCost)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.target)
	e2:SetOperation(Senya.DrawOperation)
	c:RegisterEffect(e2)
end
function cm.effect_operation_3L(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(Senya.order_table_new({}))
	e2:SetOperation(cm.op)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(m-1000)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ex:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(ex,true)
	Duel.Readjust()
	return e2,ex
end
--[[cm.reset_operation_3L={
function(e,c)
	e:SetOperation(aux.NULL)
	local copyt=Senya.order_table[e:GetLabel()]
	for tc,cid in pairs(copyt) do
		if tc and cid then
			c:ResetEffect(cid,RESET_COPY)
		end
	end
end,
}]]
function cm.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER)
end
function cm.val(c)
	if c:IsType(TYPE_XYZ) then
		return c:GetOriginalRank()
	else
		return c:GetOriginalLevel()
	end
end
function cm.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function cm.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=Senya.order_table[e:GetLabel()]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(cm.copyfilter,tp,0,LOCATION_MZONE,nil)
	--local maxg=g:GetMaxGroup(cm.val) or Group.CreateGroup()
	local dg=exg:Filter(cm.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(cm.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(cm.rcon(e:GetCondition(),tc,copyt))	  
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		copyt[tc]=Senya.CopyEffectExtraCount(c,Senya.CheckKoishiCount(c),tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
	Card.RegisterEffect=f
end
function cm.rcon(con,tc,copyt)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(m-1000) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		return not con or con(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Senya.check_set_3L(c)
end
function cm.DiscardHandCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.cfilter(c,tp)
	if c:GetSummonPlayer()==tp or c:GetMaterialCount()<=0 then return false end
	for i,tty in pairs({SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK}) do
		if c:IsSummonType(tty) then return true end
	end
	return false
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil,tp)
	local ct=1
	g:ForEach(function(c)
		ct=ct+c:GetMaterialCount()
	end)
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end