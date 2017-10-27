--Nanahira & Nanami
local m=37564534
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetValue(0x534)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(cm.rgcon)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(cm.rdcon)
	e3:SetOperation(cm.rdop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetCondition(cm.rgcon)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
end
function cm.rgcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x534)==0x534
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	return g:GetCount()==1 and Senya.NanahiraFilter(tc,true)
end
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and bit.band(e:GetHandler():GetSummonType(),0x534)==0x534
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function cm.f1(c,e,tp)
	return c:IsCode(37564765) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(e:GetHandler(),nc)) and c:IsFaceup()
end
function cm.f2(c,e,tp,g)
	return c.Senya_desc_with_nanahira and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.f3(c,e,tp)
	return c:IsCode(37564765) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(e:GetHandler(),nc))
end
function cm.filter(c)
	return c.Senya_desc_with_nanahira and bit.band(c:GetType(),TYPE_TRAP+TYPE_COUNTER)==TYPE_TRAP+TYPE_COUNTER and c:IsAbleToHand()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.f1,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not cm.rmtg(e,tp,eg,ep,ev,re,r,rp,0) or e:GetHandler():IsImmuneToEffect(e) or e:GetHandler():IsControler(1-tp) or e:GetHandler():IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.f3,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	g:AddCard(e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.f2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
	Duel.SendtoGrave(g,REASON_EFFECT)
	if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,Senya.DescriptionInNanahira(2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end