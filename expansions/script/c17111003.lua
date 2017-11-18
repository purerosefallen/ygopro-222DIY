--ブリンセス·ジュリエット
local m=17111003
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+1
function cm.initial_effect(c)
	--Change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.changecon)
	e1:SetTarget(cm.changetg)
	e1:SetOperation(cm.changeop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_LEVEL)
	e3:SetValue(cm.slevel)
	c:RegisterEffect(e3)
end
cm.is_named_with_Commander=1
function cm.IsCommander(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Commander
end
function cm.cfilter(c)
	return c:IsFaceup() and (c:IsCode(17111001) or c:IsCode(17111002))
end
function cm.changecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(12,0,aux.Stringid(m,12))
end
function cm.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 2*65536+lv
end