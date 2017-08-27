--Perfect Pretty Phantom
local m=37564546
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.NanahiraExtraPendulum(c)
	aux.AddFusionProcCodeFunRep(c,37564765,aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),2,2,true,true)
	Senya.AddSelfFusionProcedure(c,LOCATION_ONFIELD,Duel.Release)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Group.CreateGroup()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then tg:AddCard(tc) end
	if e:GetHandler():IsRelateToEffect(e) then tg:AddCard(e:GetHandler()) end
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end