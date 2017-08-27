--Secret Scarlet
local m=37564558
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsCode,37564765),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.traptarget)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
end
function cm.traptarget(e,c)
	local ec=e:GetHandler()
	local seq=c:GetSequence()
	local eseq=ec:GetSequence()
	if eseq>4 then return false end
	if ec:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and eseq>0 and seq==eseq-1 then return true end
	if ec:IsLinkMarker(LINK_MARKER_BOTTOM) and seq==eseq then return true end
	if ec:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and eseq<4 and seq==eseq+1 then return true end
	return false
end
function cm.filter(c,g)
	return g:IsContains(c)
end
function cm.sfilter(c)
	return c.Senya_desc_with_nanahira and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local se=tc:IsCode(37564765)
		local g=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
		if Duel.Destroy(tc,REASON_EFFECT)>0 and se and g:GetCount()>0 and Duel.SelectYesNo(tp,m*16+1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end