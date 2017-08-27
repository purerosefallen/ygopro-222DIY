--剑舞-风早神人
function c5200001.initial_effect(c)
	--特招效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c5200001.spcon)
	c:RegisterEffect(e1)  
	--检索效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5200001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)--效果种类：检索卡组效果+加入手牌效果
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)--效果类型：诱发选发效果
	e2:SetCode(EVENT_SUMMON_SUCCESS)---发动时机：召唤成功
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)----效果时点：可在伤害步骤发动+场合效果
	e2:SetCountLimit(1,5200001)----效果使用次数限制：ID1次
	e2:SetTarget(c5200001.target)----效果处理判断函数：也就是下面的：c5200001.target函数  用来判断卡组有没有可以检索的怪兽，如果有就可以发动效果
	e2:SetOperation(c5200001.operation)-----效果处理内容函数：也就是下面的：c5200001.operation函数  用来处理效果内容
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)   -------发动时机：特殊召唤成功
	c:RegisterEffect(e3) 
	--墓地回收
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5200001,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,5200001)
	e4:SetCondition(c5200001.gthcon)
	e4:SetTarget(c5200001.gthtg)
	e4:SetOperation(c5200001.gthop)
	c:RegisterEffect(e4) 
	--增加属性
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_ADD_ATTRIBUTE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--cannot be material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetValue(c5200001.splimit)
	c:RegisterEffect(e6) 
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
end
----墓地回收--------------------------------------------------------------
function c5200001.gthcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c5200001.gthfilter(c)
	return c:IsSetCard(0x360) and c:IsType(TYPE_MONSTER) and not c:IsCode(5200001) and c:IsAbleToHand()
end
function c5200001.gthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c5200001.gthfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5200001.gthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c5200001.gthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c5200001.gthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

----检索卡组效果--------------------------------------------------------------
function c5200001.filter(c) 
	return c:IsSetCard(0x360) and c:IsType(TYPE_MONSTER) and not c:IsCode(5200001) and c:IsAbleToHand()
end
function c5200001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5200001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5200001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-----特殊召唤效果-----------------------------------------------------------
function c5200001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c5200001.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x360)
end